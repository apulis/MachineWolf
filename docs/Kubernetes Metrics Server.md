#!/bin/bash

# 生成整个文件加的所有文件md5 到checksums.md5
apt install -y md5deep
md5deep -rel -o f . >> ./checksums.md5


# 更新 
k8s.gcr.io/metrics-server/metrics-server:v0.4.1

registry.aliyuncs.com/google_containers/metrics-server/metrics-server:v0.4.1

kubectl edit deployment -n kube-system metrics-server

# /etc/hosts 中 127.0.0.1 localhost 不能注释否则calico起不来




# 安装jupyter 插件
pip install xeus-python notebook  -i https://pypi.tuna.tsinghua.edu.cn/simple


# 安装ZFS 
# zypper addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Leap_15.2/filesystems.repo
# zypper refresh
# zypper install zfs


Installation
----------------------------------------------------------------------------

# metrix-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl get deployment metrics-server -n kube-system

kuber-dashboard

# Kubernetes Dashboard
-----------------------------------------------------------------------------
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml
local access :
```
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
```



设置代理：

 export http_proxy="http://proxy-XXXXX"
 export https_proxy="https://proxy-XXXXX:"

取消代理：

unset http_proxy

unset https_proxy


* 安装helm

`zypper install helm`

+ Initialize a Helm Chart Repository
        helm repo add stable https://charts.helm.sh/stable
        helm search repo stable

* 备份metrix-server

docker save -o metrics-server-v0.4.1.tar k8s.gcr.io/metrics-server/metrics-server:v0.4.1
docker save -o kube-dashboard-v2.0.0-beta1.tar kubernetesui/dashboard:v2.0.0-beta1
docker save -o metrics-scraper-v1.0.0.tar kubernetesui/metrics-scraper:v1.0.0
docker save -o tigera-operator-v1.13.2.tar quay.io/tigera/operator:v1.13.2


* 停止pod
kubectl scale --replicas=0 deployment/dashboard-metrics-scraper -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-dashboard -n kubernetes-dashboard
kubectl scale --replicas=0 deployment/kubernetes-metrics-scraper -n kubernetes-dashboard

kubectl scale --replicas=1 deployment/metrics-server -n kube-system 

[how to stop/pause a pod in kubernetes](https://stackoverflow.com/questions/54821044/how-to-stop-pause-a-pod-in-kubernetes)


* 创建用户和账号
-------------------------------------------------------------------------------------------
kubectl create serviceaccount dashboard-admin -n kube-system
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin -serviceaccount=kube-system:dashboard-admin
kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')

Name:         dashboard-admin-token-md5g8
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
              kubernetes.io/service-account.uid: 0a01a970-dae1-4fa6-8326-982d5e16ef35

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1066 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImR6S05ENHB4QlRqNmcxcjhzNEdSc1hGeVhWWWtvZlktSkQ4V2lHODJVNmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbWQ1ZzgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGEwMWE5NzAtZGFlMS00ZmE2LTgzMjYtOTgyZDVlMTZlZjM1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.NphmgVFtBzzWSHDRYcEzgcqER3IJcFP8FTd9fuUZGaaVow1eOoTAR5QiGpTMaKrg8HM4VBJKB368tbp-eCxFFbSp3HxZuwRUqwPMAAHSrp5dEshTeuk3S-m7CwACu0n77pWnURX8Xs3Q9ksbvCLxEySjQrcPOltdll0lY2bjK2z5NRLBAraaD6-9J-vOySAC5p6K6awh_ODGDNE8WhPuRPRmfL4qG58DEz3Wk7wUTv0Pix7IcjOHjjkJCYEIMDmS_Hu3w8oagMFpQxU88PPNTXk5aIXXS7beFOCXN_zz-nLW2A_h5ST9wftU3-PWGNtajTQZzZEyNyHOAJgqVgUmeg

测试环境
-----

root@master:/home/InstallationYTung# kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')
Name:         dashboard-admin-token-2znx2
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
              kubernetes.io/service-account.uid: ce059793-5b3d-4236-8f95-9d5d6b56373c

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6InROWHFkaWdjVDQxYi1EbzlTYUU5Wm5KT2c0N2FKanRLazJmaTlzTjlGYWsifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tMnpueDIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiY2UwNTk3OTMtNWIzZC00MjM2LThmOTUtOWQ1ZDZiNTYzNzNjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.rAbCzJ6QueL_9lqHcA36JGZFi_sAYvXfalpqkAOLhbLR-TsuotNFdvREXotDRLiVmZJW3buxS2qlqSddUd6elXor1J1ZlDzvGU8keFn4puQhrqsq1gB2l7FltPen4pkqgtwZ5LW0MtE6vs4kA5kDwSlGQUSR-aNlcatPUVwyy7NSlt1Sf-7sXrYkoOqvMJzl1hZMS-qnSOtWp0GuoGwzIAiNU124Z6jyM46xdx-SWd3EMAHChc919Mbqpt3pNBD6rdFrhXVgT8FXKl39rlOdhzfGscVuebK3wFWLRYa7Xy5f_9YTOYSU8ELbao9XA3PTiwGWxQnuREzk8qDWNz7JrQ
ca.crt:     1350 bytes
namespace:  11 bytes

* 设置访问端口
kubectl get svc -n kubernetes-dashboard
kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kubernetes-dashboard

root@master:/home/InstallationYTung# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.68.3.176   <none>        8000/TCP        18m
kubernetes-dashboard        NodePort    10.68.224.5   <none>        443:34549/TCP   18m