
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
|master     | master   | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.113 | root,apulis123 | 22       |
|worker01   | worker01 | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.183 | root,pulis123  | 22       |
|worker02   | worker02 | sshpass -p Aiperf@2025 ssh -p 22 root@192.168.1.107 | root,apulis123 | 22       |

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