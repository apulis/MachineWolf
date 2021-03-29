# Kubernetes Mstrics Server 配置

  **生成整个文件加的所有文件md5 到checksums.md5**

  ```bash
  apt install -y md5deep
  md5deep -rel -o f . >> ./checksums.md5
  ```

**更新**

```bash
#!/bin/bash
k8s.gcr.io/metrics-server/metrics-server:v0.4.1
# registry.aliyuncs.com/google_containers/metrics-server/metrics-server:v0.4.1
kubectl edit deployment -n kube-system metrics-server
```

> /etc/hosts 中 127.0.0.1 localhost 不能注释否则calico起不来

**安装jupyter 插件**

`pip install xeus-python notebook  -i https://pypi.tuna.tsinghua.edu.cn/simple`

**安装ZFS**

```bash
zypper addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Leap_15.2/filesystems.repo
zypper refresh
zypper install zfs
```


## Installation


### metrix-server

```bash
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# 在 container 下添加 - --kubelet-insecure-tls
kubectl apply -f ./components.yaml
kubectl get deployment metrics-server -n kube-system
kuber-dashboard
```

> ```
> echo subjectAltName = IP:worker_node_ip > extfile.cnf
> openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
> ```

### Kubernetes Dashboard

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml`

**local access :**

`kubectl  get svc -n kubernetes-dashboard`

```
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
```

**安装helm**

`zypper install helm`

+ Initialize a Helm Chart Repository
  helm repo add stable https://charts.helm.sh/stable
  helm search repo stable

### 备份metrix-server

docker save -o metrics-server-v0.4.1.tar k8s.gcr.io/metrics-server/metrics-server:v0.4.1
docker save -o kube-dashboard-v2.0.0-beta1.tar kubernetesui/dashboard:v2.0.0-beta1
docker save -o metrics-scraper-v1.0.0.tar kubernetesui/metrics-scraper:v1.0.0
docker save -o tigera-operator-v1.13.2.tar quay.io/tigera/operator:v1.13.2

### 停止pod

kubectl scale --replicas=0 deployment/dashboard-metrics-scraper -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-dashboard -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-metrics-scraper -n kubernetes-dashboard

kubectl scale --replicas=1 deployment/metrics-server -n kube-system

[how to stop/pause a pod in kubernetes](https://stackoverflow.com/questions/54821044/how-to-stop-pause-a-pod-in-kubernetes)

### 创建用户和账号

kubectl create serviceaccount dashboard-admin -n kube-system
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin -serviceaccount=kube-system:dashboard-admin
kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')

Name:         dashboard-admin-token-md5g8
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
kubernetes.io/service-account.uid: 0a01a970-dae1-4fa6-8326-982d5e16ef35

Type:  kubernetes.io/service-account-token


ca.crt:     1066 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImR6S05ENHB4QlRqNmcxcjhzNEdSc1hGeVhWWWtvZlktSkQ4V2lHODJVNmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbWQ1ZzgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGEwMWE5NzAtZGFlMS00ZmE2LTgzMjYtOTgyZDVlMTZlZjM1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.NphmgVFtBzzWSHDRYcEzgcqER3IJcFP8FTd9fuUZGaaVow1eOoTAR5QiGpTMaKrg8HM4VBJKB368tbp-eCxFFbSp3HxZuwRUqwPMAAHSrp5dEshTeuk3S-m7CwACu0n77pWnURX8Xs3Q9ksbvCLxEySjQrcPOltdll0lY2bjK2z5NRLBAraaD6-9J-vOySAC5p6K6awh_ODGDNE8WhPuRPRmfL4qG58DEz3Wk7wUTv0Pix7IcjOHjjkJCYEIMDmS_Hu3w8oagMFpQxU88PPNTXk5aIXXS7beFOCXN_zz-nLW2A_h5ST9wftU3-PWGNtajTQZzZEyNyHOAJgqVgUmeg

### 测试环境测试环境

```bash
root@master:/home/InstallationYTung# kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')
Name:         dashboard-admin-token-2znx2
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
kubernetes.io/service-account.uid: ce059793-5b3d-4236-8f95-9d5d6b56373c

Type:  kubernetes.io/service-account-token


token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlZ6UzJaWEtScFYxYTBmZ2o3bW0yZDdtWWZNTVJuX0w5TXMwRWxsc0ZvMkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ3ZWF2ZS1uZXQtdG9rZW4tczZrNmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoid2VhdmUtbmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTFhYWNjNDItZTk0ZS00YjIzLWE5YWUtYmE1NmZmY2QyNzk3Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOndlYXZlLW5ldCJ9.o0m-U3Ur0nxxdjj8l3Wu7vLSHU9iJQsi3_vYysq3NyOURjoC-IiEOMu4vgp3ITClsh-i6dxFrURdis-wH2bFwP31Bnz5UScor6iNCHSFwaZ7f_oGlkcgqCXBNvvhX2kuVZgs12UT0jHXxhKvRNXzUEVYoS0XnmiGY04ICHFPxdo0tnclI4pb20cGl1bTGHXh0HcZkaN-UJIwHRxt7jNd7OoOeXL4hE9BY1TAIkPKt4a9Uz7Bg-kWnp3V87czZwv38eyy76oqr7HVjuRvOiDEsHwi4jyU76Nd-Plhl6bIxHZpIolTfYRBgMqQG6e3mDTrp6oK3A6bSS_DxiRE2tNxqA
ca.crt:     1350 bytes
namespace:  11 bytes
```

* 设置访问端口
  kubectl get svc -n kubernetes-dashboard
  kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kubernetes-dashboard

root@master:/home/InstallationYTung# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.68.3.176   <none>        8000/TCP        18m
kubernetes-dashboard        NodePort    10.68.224.5   <none>        443:34549/TCP   18m


### Images list


**metrics-server: ** metrics-server-v0.4.1.tar (k8s.gcr.io/metrics-server/metrics-server:v0.4.1)


* 排查
endpoint:

kubectl get ep -A

 ds:
kubectl get ds -n kube-system

yaml 在/build 下面
