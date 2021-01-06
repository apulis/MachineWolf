
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
|device name| role     | IP                                                | account        | ssh port |
|:---------:|:--------:|:-------------------------------------------------:|:--------------:|:--------:|
|master     | master   | sshpass -p apulis123 ssh -p 22 root@192.168.1.113 | root,apulis123 | 22       |
|worker01   | worker01 | sshpass -p apulis123 ssh -p 22 root@192.168.1.171 | root,pulis123  | 22       |
|worker02   | worker02 | sshpass -p apulis123 ssh -p 22 root@192.168.1.107 | root,apulis123 | 22       |


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
    rm -rf  /etc/cni/net.d && rm -rf /root/.kube/config


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