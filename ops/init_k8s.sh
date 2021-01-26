
# sync init script 
scp -P 6022 .\init_k8s.sh root@122.51.195.199:/home/thomas/perf_k8s

kubeadm config images list

images=(  # 下面的镜像应该去除"k8s.gcr.io/"的前缀，版本换成上面获取到的版本
    kube-apiserver:v1.20.2
    kube-controller-manager:v1.20.2
    kube-scheduler:v1.20.2
    kube-proxy:v1.20.2
    pause:3.2
    etcd:3.4.13-0
    coredns:1.7.0
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
    docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done

# 初始化环境
kubeadm init --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=all  --v=6

# 配置授权信息
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 配置网络组件
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

## 参考 https://docs.projectcalico.org/getting-started/kubernetes/quickstart

# master as worker 
kubectl taint nodes --all node-role.kubernetes.io/master-

# 查看是否安装成功
kubectl get pods -n kube-system

# 加入节点

kubeadm join 192.168.1.204:6443 --token ktlnom.duug23bsytv0mmyv --discovery-token-ca-cert-hash sha256:73df83dd79f4b0007ca88dcf84ddf75afddf8b0f2351b212651e2d73a980bfc8