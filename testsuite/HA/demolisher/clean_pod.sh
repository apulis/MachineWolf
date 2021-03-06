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
