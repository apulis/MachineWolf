性能测试服务器初始化
================================================================

1. 系统安装和配置

   * 安装 15.2 lTS 

   * 更新安装源：

    ```zypper
    mkdir -p /etc/zypp/repos.d/repo.bak
    mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo.bak/

    sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/ OSS
    sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/ NON-OSS
    sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/ UPDATE-OSS
    sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/ UPDATE-NON-OSS
    sudo zypper ar -fcg https://mirrors.bfsu.edu.cn/packman/suse/openSUSE_Leap_15.2 PACKMAN
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
The global configuration file should look like the example below (please adjust TCP/IP addresses and Port numbers to match the environment)
Please edit /etc/sysconfig/proxy with the following proxy values:

    ```
    PROXY_ENABLED="yes"
    HTTP_PROXY="http://192.168.0.1:3128"
    HTTPS_PROXY="http://192.168.0.1:3128"
    FTP_PROXY="http://192.168.0.1:3128"
    NO_PROXY="localhost, 127.0.0.1"
    ```
Single user proxy configuration
When it is desired or required to set a proxy configuration for a single user, please create a .bashrc file # under the users home directory, and add the following export commands :

    ```
    export http_proxy="http://192.168.0.1"
    export ftp_proxy="http://192.168.0.1"
    export https_proxy="http://192.168.0.1"
    export no_proxy="localhost, 127.0.0.1"
    ```
3. 安装docker

    zypper in docker
    systemctl restart docker
    systemctl enable docker

4. modprobe & sysctl
   
    modprobe overlay
    modprobe br_netfilter

    Edit /etc/sysctl.conf:

    net.ipv4.ip_forward = 1
    net.ipv4.conf.all.forwarding = 1
    net.bridge.bridge-nf-call-iptables = 1

    Run this command to apply:

    sysctl -p  

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
   zypper addrepo --type yum --gpgcheck-strict --refresh https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 google-k8s
   
   2. Add gpg key for repository, run command:

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

kubeadm init --pod-network-cidr=10.244.14.0/16 --ignore-preflight-errors=all --image-repository='registry.cn-hangzhou.aliyuncs.com/google_containers'

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

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

docker pull argoproj/argocli:v2.12.2
docker pull minio/minio:RELEASE.2019-12-17T23-16-33Z

docker pull argoproj/workflow-controller:v2.12.2
docker pull postgres:12-alpine
https://github.com/argoproj/argo/

kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml

* `Connecting to raw.githubusercontent.com failed: Connection refused.`
    查询raw.githubusercontent.com的真实IP
    在https://www.ipaddress.com/ 查询raw.githubuercontent.com的真实IP。

    修改hosts
    在/etc/hosts/中绑定查到的host，例如：

    sudo vim /etc/hosts
    #绑定host
    199.232.28.133 raw.githubusercontent.com

* 参考： https://www.jianshu.com/p/5c1a352ba242




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

