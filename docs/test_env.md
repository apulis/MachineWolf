新能测试调试环境基础信息
--------------------------------------------------------------------------------------------

* 基本信息
    + Arch: x86-64 Master + N*x86-64 GPU-2070 Worker
    + OS: Ubuntu Server 18.04.1 arm64
    + Apulis Platform Version: v1.3.0
    + Model & Datasets:
    + TestPlan:

* k8s hosts

```
127.0.0.1      localhost

192.168.1.113    master01
192.168.1.113    master01.sigsus.cn
192.168.1.113    harbor.sigsus.cn 
192.168.1.171    worker01
192.168.1.171    worker01.sigsus.cn
192.168.1.107    worker02
192.168.1.107    worker02.sigsus.cn
```

* 集群配置
|device name| role     | IP                                                  | account        | ssh port |
|:---------:|:--------:|:---------------------------------------------------:|:--------------:|:--------:|
|master     | master   | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.198 | root,apulis123 | 22       |
|worker01   | worker01 | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.196 | root,pulis123  | 22       |
|worker02   | worker02 | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.235 | root,apulis123 | 22       |

* 数据和存储 
- nfs （master  HDD）
- DB   (master Mysql)

* 算力
{
    "host": "worker01",
    "gpuType": "gpu",
    "vendor": "nvidia"
}，
{
    "host": "worker02",
    "gpuType": "gpu",
    "vendor": "nvidia"
}

* 恢复操作

    # 重置集群
    kubeadm reset 
    rm -rf  /etc/cni/net.d && rm -rf /root/.kube/configkubeadm


参考公共服务
-------------------------------------------------------------------------------------
* 公司Harbor

```
# 222harbor 登录证书目录
/etc/docker/certs.d/
/opt/harbor/cert/
```

tmp_notes:
--------------------------------------------------------------------------------------
* Lose or Update pod images


docker load -i harbor.sigsus.cn:8443-sz_gongdianju-apulistech-mxnet:2.0.0-gpu-py3.tar
docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/mxnet:2.0.0-gpu-py3
docker load -i harbor.sigsus.cn:8443-sz_gongdianju-apulistech-tensorflow:2.3.0-gpu-py3.tar
docker push  harbor.sigsus.cn:8443/sz_gongdianju/apulistech/tensorflow:2.3.0-gpu-py3
docker load -i harbor.sigsus.cn:8443-sz_gongdianju-apulistech-ubuntu:18.04-amd64.tar
harbor.sigsus.cn:8443/sz_gongdianju/apulistech/ubuntu:18.04-amd64

GPU服务器
--------------------------------------------------------------------------------------

1. 同步代码


2. 安装基础环境

3. 安装GPU驱动

4. 加入集群

新机扩容：

1、 在新的worker机器上安装apt里面的包

```
dpkg -i ./*
```

2、 在新的worker机器上安装python2.7里面的包

```
pip install setuptools* 
pip install wheel*
python setup.py bdist_wheel
pip install --no-index --find-links ./ ./*
```

3、在新的worker机器上添加dlwsadmin账号

```
DLWS_HOME="/home/dlwsadmin"
 useradd -d ${DLWS_HOME} -s /bin/bash dlwsadmin
    RC=$?
    case "$RC" in
        "0") echo "User created..."
             echo "Set up default password 'dlwsadmin' ..."
             echo "dlwsadmin:dlwsadmin" | chpasswd
             break;
             ;;
        "9") echo "User already exists..."
             break;
             ;;
        *)
            echo "Can't create user. Will Exit..."
            exit 2
            ;;
    esac
    
    printf "Done to crate 'dlwsadmin'\n"

    mkdir -p ${DLWS_HOME}
    chown -R dlwsadmin:dlwsadmin ${DLWS_HOME}
    echo "dlwsadmin ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/dlwsadmin
    chmod 0440 /etc/sudoers.d/dlwsadmin
    sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers
```

4、同步集群各节点的ssh秘钥

5、拷贝docker harbor证书到新的机器上
例：

```
scp -r /etc/docker/certs.d/ root@worker04:/etc/docker
```

6、到新的worker机器上登录harbor

```
docker login harbor.sigsus.cn:8443
```


7、到新机器上docker pull k8s的基础镜像

```
  k8s_images=(
    k8s.gcr.io/kube-proxy:v1.18.2
    k8s.gcr.io/kube-apiserver:v1.18.2
    k8s.gcr.io/kube-controller-manager:v1.18.2
        k8s.gcr.io/kube-scheduler:v1.18.2
    k8s.gcr.io/pause:3.2
    k8s.gcr.io/etcd:3.4.3-0
    k8s.gcr.io/coredns:1.6.7
    plndr/kube-vip:0.1.8
  )
  for image in ${k8s_images[@]}
  do
    docker pull harbor.sigsus.cn:8443/sz_gongdianju/${image}-arm64
    docker tag harbor.sigsus.cn:8443/sz_gongdianju/${image}-arm64  $image
  done

docker pull harbor.sigsus.cn:8443/sz_gongdianju/ascend-k8sdeviceplugin:v0.0.1-arm64
```

8、关闭swap，在新的worker机器上执行：

```
swapoff -a
```

9、到master部署目录下执行，期间需要输入 ssh dlwsadmin@worker的密码，及dlwsadmin（账号密码一样）

```
./deploy.py --verbose kubeadm join ha
./deploy.py --verbose -y kubernetes labelservice
./deploy.py --verbose -y labelworker
```

10、挂载nfs，到master部署目录下执行：

```
./deploy.py --verbose mount
```

如果不成功，则试试在新的worker机器上试试： 

```
mkdir /mntdlws
```

11、等待pod正常running



12、npu使用情况收集：

./deploy.py --background --sudo runscriptonall scripts/npu/npu_info_gen.py

13. kube-dashboard login token
 kubectl get svc -n kubernetes-dashboard

Name:         weave-net-token-s6k6f
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: weave-net
              kubernetes.io/service-account.uid: 91aacc42-e94e-4b23-a9ae-ba56ffcd2797

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1350 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlZ6UzJaWEtScFYxYTBmZ2o3bW0yZDdtWWZNTVJuX0w5TXMwRWxsc0ZvMkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ3ZWF2ZS1uZXQtdG9rZW4tczZrNmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoid2VhdmUtbmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTFhYWNjNDItZTk0ZS00YjIzLWE5YWUtYmE1NmZmY2QyNzk3Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOndlYXZlLW5ldCJ9.o0m-U3Ur0nxxdjj8l3Wu7vLSHU9iJQsi3_vYysq3NyOURjoC-IiEOMu4vgp3ITClsh-i6dxFrURdis-wH2bFwP31Bnz5UScor6iNCHSFwaZ7f_oGlkcgqCXBNvvhX2kuVZgs12UT0jHXxhKvRNXzUEVYoS0XnmiGY04ICHFPxdo0tnclI4pb20cGl1bTGHXh0HcZkaN-UJIwHRxt7jNd7OoOeXL4hE9BY1TAIkPKt4a9Uz7Bg-kWnp3V87czZwv38eyy76oqr7HVjuRvOiDEsHwi4jyU76Nd-Plhl6bIxHZpIolTfYRBgMqQG6e3mDTrp6oK3A6bSS_DxiRE2tNxqA


* 更新模块镜像
docker pull harbor.apulis.cn:8443/release/apulistech/user_backend/amd64:v1.5.0-rc6-ci
docker pull harbor.apulis.cn:8443/release/apulistech/user_fronted/amd64:v1.5.0-rc6-ci
docker pull harbor.apulis.cn:8443/release/apulistech/aiarts-frontend/amd64:v1.5.0
docker pull harbor.apulis.cn:8443/release/apulistech/aiarts-backend/amd64:v1.5.0-rc7-ci
docker pull harbor.apulis.cn:8443/release/apulistech/dlworkspace-restfulapi2/amd64:v1.5.0-rc7-ci
docker pull harbor.apulis.cn:8443/release/apulistech/dlworkspace-webui3/amd64:v1.5.0-rc7-ci


docker tag harbor.apulis.cn:8443/release/apulistech/user_backend/amd64:v1.5.0-rc6-ci             harbor.sigsus.cn:8443/aiarts/apulistech/custom-user-dashboard-backend:v1.5.0-rc6
docker tag harbor.apulis.cn:8443/release/apulistech/user_fronted/amd64:v1.5.0-rc6-ci             harbor.sigsus.cn:8443/aiarts/apulistech/custom-user-dashboard-frontend:v1.5.0-rc6
docker tag harbor.apulis.cn:8443/release/apulistech/aiarts-frontend/amd64:v1.5.0                 harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace_aiarts-frontend:v1.5.0-rc6
docker tag harbor.apulis.cn:8443/release/apulistech/aiarts-backend/amd64:v1.5.0-rc7-ci           harbor.sigsus.cn:8443/aiarts/apulistech/aiarts-backend:v1.5.0-rc6
docker tag harbor.apulis.cn:8443/release/apulistech/dlworkspace-restfulapi2/amd64:v1.5.0-rc7-ci  harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace-restfulapi2:v1.5.0-rc6
docker tag harbor.apulis.cn:8443/release/apulistech/dlworkspace-webui3/amd64:v1.5.0-rc7-ci       harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace-webui3:v1.5.0-rc6

docker push harbor.sigsus.cn:8443/aiarts/apulistech/custom-user-dashboard-backend:v1.5.0-rc6
docker push harbor.sigsus.cn:8443/aiarts/apulistech/custom-user-dashboard-frontend:v1.5.0-rc6
docker push harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace_aiarts-frontend:v1.5.0-rc6
docker push harbor.sigsus.cn:8443/aiarts/apulistech/aiarts-backend:v1.5.0-rc6
docker push harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace-restfulapi2:v1.5.0-rc6
docker push harbor.sigsus.cn:8443/aiarts/apulistech/dlworkspace-webui3:v1.5.0-rc6


harbor.singapore.cn:8443/hz_openlab/apulistech/dlworkspace_openresty:v1.5.0

* 资源限制
```bash
resource_limit:
  huawei_npu_arm64:  # device_type
    cpu:    2
    memory: 400Mi

./service_ctl.sh restart restfulapi2
./service_ctl.sh restart jobmanager2

cat /root/build/restfulapi2/config.yaml 
resource_limit: {"huawei_npu_arm64": {"cpu": 22, "memory": "80Gi"}}
```

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |   sudo tee /etc/apt/sources.list.d/nvidia-docker.list


curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey |   sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list |   sudo tee /etc/apt/sources.list.d/libnvidia-container.list
sudo apt-get update
sudo apt-get install nvidia-container-toolkit

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list


  /var/log/nvidia-installer.log                                                                OK

                                                                  OK
* 增加镜像列表
```sql
insert into images (image_type, image_full_name, details) values ('tensorflow', 'apulistech/horovod:0.2.0', '{"desc":"描述信息","category":"normal","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
insert into images (image_type, image_full_name, details) values ('mindspore', 'apulistech/mindspore:1.1.0', '{"desc":"描述信息","category":"normal","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
insert into images (image_type, image_full_name, details) values ('tensorflow', 'apulistech/horovod:0.2.0', '{"desc":"描述信息","category":"hyperparameters","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
insert into images (image_type, image_full_name, details) values ('mindspore', 'apulistech/mindspore:1.1.0', '{"desc":"描述信息","category":"hyperparameters","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
select * from public.images;
delete from public.images where image_full_name like '%npu%';
```
