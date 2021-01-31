
# 循环遍历清理Evicted的pod
#!/bin/bash
namespace=("default" "kube-system"  "knative-serving"  "volcano-system", "istio-system")
pod_status=("Evicted" "ImagePullBackOff"  "ContainerCreating" "ErrImagePull" "ContainerCreating" "Pending")

for istatus in ${pod_status[@]};
do
  for iname in ${namespace[@]};
  do
    echo "Get un-healthy pod:" $iname : $istatus
    for each in $(kubectl get pods -n $iname|grep $istatus|awk '{print $1}');
    do
      kubectl delete pods $each -n $iname
    done
  done
done


# 添加docker用户组，一般已存在，不需要执行
sudo groupadd docker     
# 将登陆用户加入到docker用户组中
sudo gpasswd -a $USER docker
# 更新用户组
newgrp docker   
# 测试docker命令是否可以使用sudo正常使用
docker version  

