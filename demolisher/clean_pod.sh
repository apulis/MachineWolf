
# 循环遍历清理Evicted的pod
#!/bin/bash
namespace=("default" "kube-system" "knative-serving" "volcano-system" "istio-system")
echo "echo array directly:" $A
for iname in ${namespace[@]};
do
  for each in $(kubectl get pods -n $iname|grep Evicted|awk '{print $1}');
  do
    kubectl delete pods $each -n $iname
  done
done

# 循环遍历清理Evicted的pod
#!/bin/bash
namespace=("default" "kube-system" "knative-serving" "volcano-system" "istio-system")
echo "echo array directly:" $A
for iname in ${namespace[@]};
do
  for each in $(kubectl get pods -n $iname|grep ImagePullBackOff|awk '{print $1}');
  do
    kubectl delete pods $each -n $iname
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

