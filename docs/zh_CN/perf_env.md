性能测试服务器初始化
================================================================

0. 集群配置


|网络设备   |角色    |访问链接                                                 |业务账号       |管理IP        |管理账号       |
|:--------:|:------:|:------------------------------------------------------:|:------------:|:------------:|-------------:|
|PC        |master  | sshpass -p apulis@2025 ssh -p 2025 root@192.168.1.204    |root/Aiops@18c|192.168.1.17  |ADMIN/apulis18c|
|VM        |worker01| sshpass -p apulis@2025 ssh -p 2025 root@192.168.1.217    |root/Aiops@18c|192.168.1.21  |默认 |
|Docker    |dev env | local                                                  |root/Aiops@18c|192.168.1.15  |默认 |

* Remote Desktop: ssh Admin@192.168.1.x

ip route add default via 192.168.1.1 dev eth0 proto static metric 100

* frp proxy:
+ perf-server： 
- kubernetes dashboard： https://122.51.195.199:30692/#/login
    ```token
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImR6S05ENHB4QlRqNmcxcjhzNEdSc1hGeVhWWWtvZlktSkQ4V2lHODJVNmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbWQ1ZzgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGEwMWE5NzAtZGFlMS00ZmE2LTgzMjYtOTgyZDVlMTZlZjM1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.NphmgVFtBzzWSHDRYcEzgcqER3IJcFP8FTd9fuUZGaaVow1eOoTAR5QiGpTMaKrg8HM4VBJKB368tbp-eCxFFbSp3HxZuwRUqwPMAAHSrp5dEshTeuk3S-m7CwACu0n77pWnURX8Xs3Q9ksbvCLxEySjQrcPOltdll0lY2bjK2z5NRLBAraaD6-9J-vOySAC5p6K6awh_ODGDNE8WhPuRPRmfL4qG58DEz3Wk7wUTv0Pix7IcjOHjjkJCYEIMDmS_Hu3w8oagMFpQxU88PPNTXk5aIXXS7beFOCXN_zz-nLW2A_h5ST9wftU3-PWGNtajTQZzZEyNyHOAJgqVgUmeg
    ```
- argo: http://122.51.195.199:30184/workflows/
+ test-env：
- kubernetes dashboard：https://122.51.195.199:32109/#/login
    ```token
eyJhbGciOiJSUzI1NiIsImtpZCI6IlZ6UzJaWEtScFYxYTBmZ2o3bW0yZDdtWWZNTVJuX0w5TXMwRWxsc0ZvMkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ3ZWF2ZS1uZXQtdG9rZW4tczZrNmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoid2VhdmUtbmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTFhYWNjNDItZTk0ZS00YjIzLWE5YWUtYmE1NmZmY2QyNzk3Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOndlYXZlLW5ldCJ9.o0m-U3Ur0nxxdjj8l3Wu7vLSHU9iJQsi3_vYysq3NyOURjoC-IiEOMu4vgp3ITClsh-i6dxFrURdis-wH2bFwP31Bnz5UScor6iNCHSFwaZ7f_oGlkcgqCXBNvvhX2kuVZgs12UT0jHXxhKvRNXzUEVYoS0XnmiGY04ICHFPxdo0tnclI4pb20cGl1bTGHXh0HcZkaN-UJIwHRxt7jNd7OoOeXL4hE9BY1TAIkPKt4a9Uz7Bg-kWnp3V87czZwv38eyy76oqr7HVjuRvOiDEsHwi4jyU76Nd-Plhl6bIxHZpIolTfYRBgMqQG6e3mDTrp6oK3A6bSS_DxiRE2tNxqA
    ```
- apulis-platform: http://122.51.195.199:7080/AIarts/codeDevelopment (thomas/apulis@2025)
- apulis-endpoint: http://122.51.195.199:7080/endpoints/eyJwb3J0IjoiTXpJeE1EST0iLCJ1c2VyTmFtZSI6InRob21hcyJ9/lab

1. 系统安装和配置

   * 安装 15.2 lTS 

   + 基础网络配置:

    ```
    # 配置IP:

    NAME=''
    BOOTPROTO='static' # 'dhcp'
    STARTMODE='auto'
    ZONE=''
    IPADDR='192.168.1.240/24'

    # 配置路由：
    vim /etc/sysconfig/network/ifroute-eth0
    default 192.168.1.1 - eth0

    # 配置DNS：
    vim /etc/sysconfig/network/config
    NETCONFIG_DNS_STATIC_SERVERS="114.114.114.114"
    NETCONFIG_DNS_STATIC_SEARCHLIST="114.114.114.114"

    systemctl restart network
    ```

   * 更新安装源：

    ```zypper
    sudo mkdir -p /etc/zypp/repos.d/repo.bak
    sudo mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo.bak/
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/ OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/ NON-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/ UPDATE-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/ UPDATE-NON-OSS
    sudo sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/packman/suse/openSUSE_Leap_15.2 PACKMAN
    zypper ref
    ```
    
    ```k8s
    vim /etc/yum.repos.d/kube.repo

    [kubernetes]
    name=kubernetes
    enabled=1
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    gpgcheck=1
    gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg

    # 安装证书
    wget https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    rpm --import rpm-package-key.gpg
    ```

2. opensuse 设置系统代理

Global proxy configuration
Please edit /etc/sysconfig/proxy with the following proxy values:

    ```
    PROXY_ENABLED="yes"
    HTTP_PROXY="http://192.168.0.1:8899"
    HTTPS_PROXY="http://192.168.0.1:8899"
    FTP_PROXY="http://192.168.0.1:8899"
    NO_PROXY="localhost, 127.0.0.1"
    ```

3. 安装docker
    ```bash
    zypper in docker
    systemctl restart docker
    systemctl enable docker
    ```
4. modprobe & sysctl
   
    ```bash
    modprobe overlay
    modprobe br_netfilter

    Edit /etc/sysctl.conf:

    net.ipv4.ip_forward = 1
    net.ipv4.conf.all.forwarding = 1
    net.bridge.bridge-nf-call-iptables = 1

    Run this command to apply:

    sysctl -p  
    ```

* 解决 docker 报错: `Error starting daemon: error initializing graphdriver: backing file system is unsupported for this graph driver`
发现了关键字:   graphdriver=btrfs 以及之前的报错有提示:  `error msg="'overlay2' requires kernel 4.7 to use on btrfs"`

    ```bash
    # 所以尝试修改 /etc/sysconfig/docker-storage 为:
    DOCKER_STORAGE_OPTIONS="--storage-driver btrfs "

    # 重新启动docker: 

    systemctl restart docker.service

    # opensuse 默认文件系统为 btrfs
    cat /proc/filesystems | grep btrfs

    df -Th
    /dev/mapper/data_vg-var            btrfs      **G  407M   **G   1% /var
    /dev/mapper/data_vg-var_lib        btrfs      **G  232M   **G   1% /var/lib
    /dev/mapper/data_vg-var_lib_docker btrfs      **G   17M   **G   1% /var/lib/docker

    sudo cat /proc/filesystems | grep btrfs

        btrfs
    # docker 默认overlay2
    # "storage-driver": "overlay2" 
    # Edited /etc/docker/daemon.json as below

    {
    "storage-driver": "btrfs"
    }

    ```

* 切换docker 文件系统为btrfs

    *https://docs.docker.com/storage/storagedriver/btrfs-driver/*

    1. 查看系统的文件类型

    grep btrfs /proc/filesystems
    btrfs

    2. 停止docker

    systemctl stop docker.service\

    4. 格式化docker文件系统目录

    mkfs.btrfs -f /dev/sda
    # 查看未挂载的文件系统类型
    lsblk -f
    mkfs.btrfs -f /dev/sda1
    mkfs.btrfs -f /dev/sda2

    5. 挂在目录到 /var/lib/docker

    一般将 docker 文件系统挂在系统盘之外的存储空间，避免影响到系统和k8s稳定性
    如果是RAID，需要创建目录或划分区;如果是独立硬盘建议划分区
    sudo mount -t btrfs /dev/sda1 /var/lib/docker
    mount /dev/sda2 /mnt/fd
    sudo mount -t btrfs /dev/sda1 /var/lib/docker

    /dev/sda2      btrfs     500G  3.8M  498G   1% /mnt/fd
    /dev/sda1      btrfs     432G  3.7G  427G   1% /var/lib/docker


    + 永久挂载

    vim /etc/fstab
    `UUID=27d8f541-30d1-4e78-b798-bd8f683ff337  /var/lib/docker      btrfs     defaults        0      0`
    `UUID=3122d2a7-22fc-4c56-9e57-ce0a544f03f1  /mnt/fd      btrfs     defaults        0      0`

5. 安装 k8s

   1. ADD k8s Repository

    cat <<EOF > /etc/zypp/repos.d/google-k8s.repo
    [google-k8s]
    name=google-k8s
    enabled=1
    autorefresh=1
    #baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    type=rpm-md
    gpgcheck=1
    repo_gpgcheck=1
    pkg_gpgcheck=1
    EOF

   2. 如果是goolge源，Add gpg key for repository, run command:

    rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg

   3. Refresh repository, run command:

    zypper refresh google-k8s

    Install kubeadm,kubectl & kubelet

4. Install a bundling package to completed your kubernetes cluster:

    `zypper in kubelet  kubernetes-cni kubeadm  cri-tools kubectl  socat`

    Ignoring conntrack breakout, just pick:
    ```
    Solution 2: break kubelet-1.15.4-0.x86_64 by ignoring some of its dependencies Choose from above solutions by number or skip, retry or cancel [1/2/s/r/c] (c): 2 ...

    Solution 3: break kubelet-1.13.3-0.x86_64 by ignoring some of its dependencies Choose from above solutions by number or skip, retry or cancel [1/2/3/s/r/c] (c): 3
    ```

5. 使用kubeadm 初始化k8s集群

* 生成初始化配置
kubeadm config print init-defaults > kubeadm-config.yaml
修改脚本中的：advertiseAddress：为本机IP
             imageRepository：ali源<registry.cn-hangzhou.aliyuncs.com/google_containers>
其他需要指定的：
    --kubernetes-version    #指定Kubernetes版本
    --pod-network-cidr    #指定pod网络段
    --service-cidr    #指定service网络段
    --ignore-preflight-errors=Swap    #忽略swap报错信息

* 指定配置
kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs

kubeadm init --config=kubeadm-config.yaml --pod-network-cidr=10.244.14.0/16 --ignore-preflight-errors=all --upload-certs --v=6 

kubeadm init --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.14.0/16 --ignore-preflight-errors=all --upload-certs --v=6 

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf


`rm -rf $HOME/.kube/config && rm -rf /etc/cni/net.d`

* k8s 不支持swap 需要关闭
  sudo swapoff -a 
vim /etc/fstab 将swap注释
* 提示文件系统不支持DOCKER_GRAPH_DRIVER: btrfs

--ignore-preflight-errors=all 

6. 查看集群状态
kubectl get pods --all-namespaces --watch
如果有组建比如coredns 状态为pending，则要按照网络组件，推荐weavenet

4.2. 安装weave 网络组建

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sysctl net.bridge.bridge-nf-call-iptables=1

docker pull docker.io/weaveworks/weave-npc:2.7.0
docker pull docker.io/weaveworks/weave-kube:2.7.0

7. 加入worker节点

kubeadm join 192.168.99.101:6443 --token x8wb20.f8czwt7sdxbvprdh --discovery-token-ca-cert-hash sha256:5226d23fa710d7ca86443ca52665c5b7d0526aced2985da4b88b3cfdcd0deb97


**备份软件包**

zypper --pkg-cache-dir /tmp install --download-only --no-recommends

* 参考链接

https://nugi.abdiansyah.com/how-to-kubernetes-in-opensuse-leap-15-1-hardest-way/
https://en.opensuse.org/Kubic:kubeadm
https://stackoverflow.com/questions/62795930/how-to-install-kubernetes-in-suse-linux-enterprize-server-15-virtual-machines


* 默认情况下master 不负载，设置master也可以创建pod
kubectl get nodes
NAME    STATUS   ROLES                  AGE   VERSION
tomas   Ready    control-plane,master   62m   v1.20.1

kubectl taint nodes tomas node-role.kubernetes.io/master-
node/tomas untainted

    + 参考：https://www.cnblogs.com/riseast/p/12938434.html



部署argo
-------------------------------------------------------------
    ```
    docker pull argoproj/argocli:v2.12.2
    docker pull minio/minio:RELEASE.2019-12-17T23-16-33Z

    docker pull argoproj/workflow-controller:v2.12.2
    docker pull postgres:12-alpine
    https://github.com/argoproj/argo/

    kubectl create namespace argo
    wget https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml .
    kubectl apply -n argo -f ./install.yam
    ```

* `Connecting to raw.githubusercontent.com failed: Connection refused.`
    查询raw.githubusercontent.com的真实IP
    在https://www.ipaddress.com/ 查询raw.githubuercontent.com的真实IP。

    修改hosts
    在/etc/hosts/中绑定查到的host，例如：

    sudo vim /etc/hosts
    #绑定host
    199.232.28.133 raw.githubusercontent.com

* 参考： https://www.jianshu.com/p/5c1a352ba242

* argo cli

    ```
    # Download the binary
    curl -sLO https://github.com/argoproj/argo/releases/download/v2.12.7/argo-linux-amd64.gz

    # Unzip
    gunzip argo-linux-amd64.gz

    # Make binary executable
    chmod +x argo-linux-amd64

    # Move binary to path
    mv ./argo-linux-amd64 /usr/local/bin/argo

    # Test installation
    argo version
    ```

**附：**
---

* 设置office365邮箱登录

点击文件 >账户设置 >账户设置 > 新建 > 输入账号后选择高级选项 > 手动设置账户 > 连接  > 然后按照您的参数进行配置并配置成功。

IMAP:
服务器：outlook.office365.com
端口：993
加密：TLS

SMTP:
服务器：smtp.office365.com
端口：587
加密：STARTTLS

* 备份数据：

docker save -o perf-argocli.tar                     argoproj/argocli:v2.12.2                       
docker save -o perf-workflow-controller.tar         argoproj/workflow-controller:v2.12.2                        
docker save -o perf-kube-proxy.tar                  registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.20.1                       
docker save -o perf-kube-controller-manager.tar     registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.20.1                       
docker save -o perf-kube-apiserver.tar              registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.20.1                       
docker save -o perf-kube-scheduler.tar              registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.20.1                        
docker save -o perf-postgres.tar                    postgres:12-alpine                      
docker save -o perf-unifi-controller.tar            linuxserver/unifi-controller:latest                         
docker save -o perf-etcd.tar                        registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.4.13-0                       
docker save -o perf-weave-npc.tar                   weaveworks/weave-npc:2.7.0                          
docker save -o perf-weave-kube.tar                  weaveworks/weave-kube:2.7.0                          
docker save -o perf-coredns.tar                     registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.7.0                          
docker save -o perf-pause.tar                       registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2                            
docker save -o perf-minio.tar                       minio/minio:RELEASE.2019-12-17T23-16-33Z  
