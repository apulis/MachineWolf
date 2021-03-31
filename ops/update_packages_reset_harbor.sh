#!/bin/bash

#=========================================================================================================================
# Info: 批量更新镜像
# Creator: thomas
# Update: 2021-03-16
# Tool version: 0.1.0
# Support Platform Version: Apulis AI Platform v2.0.0
#=========================================================================================================================

local_harbor_passwd=`cat credentials/harbor.pwd`
public_hub="harbor.atlas.cn:8443"
public_project="sz_gongdianju"
local_hub="harbor.atlas.cn:8443"
local_project="apulis"
package_list=(  "apulistech/grafana:6.7.4"          \
                "apulistech/grafana-zh:6.7.4"       \  
                "prom/node-exporter:v0.18.1"         \  
                "nvidia/k8s-device-plugin:1.11"      \  
                "bash:5"                             \
                "apulistech/watchdog:1.9"            \ 
                "vc-webhook-manager:v0.0.1"          \  
                "vc-scheduler:v0.0.1"                \  
                "vc-controller-manager:v0.0.1"       \
                "apulistech/kfserving-kube-rbac-proxy:latest"     \
                "apulistech/knative-serving-activator:latest"     \
                "apulistech/knative-serving-autoscaler:latest"    \
                "apulistech/knative-serving-controller:latest"    \
                "apulistech/knative-net-istio-webhook:latest"     \
                "apulistech/knative-net-istio-controller:latest"  \ 
                "apulistech/knative-serving-webhook:latest"       \
                "apulistech/istio-proxy:latest"                   \
                "apulistech/istio-pilot:latest"                   \
                "apulistech/aiarts-backend:v3.0.0-songshanhu"     \
                "redis:5.0.6-alpine"                              \
                "apulistech/dlworkspace_data-platform-backend_amd64:latest"  \
                "harbor.atlas.cn:8443/sz_gongdianju/apulistech/dlworkspace_image-label_amd64:latest"  \
                "apulistech/nginx:1.9"    \
                "jessestuart/prometheus-operator:v0.38.0"   \
                "apulistech/dlworkspace_gpu-reporter:latest"  \
                "apulistech/kfserving-kube-rbac-proxy:latest"  \
                "apulistech/kfserving-manager:latest"  \
                "busybox:1.28"  )

docker logout
docker login -u admin -p $local_harbor_passwd $local_hub
for ipackage in ${package_list[@]}
do

# docker pull ${public_hub}/${public_project}/${ipackage}

echo "=========================: "    ${local_hub}/${local_project}/${ipackage}
docker tag ${public_hub}/${public_project}/${ipackage}   ${local_hub}/${local_project}/${ipackage}
docker push ${local_hub}/${local_project}/${ipackage}
# Restart pod kubectl delete pod -n ${kube_namespace}  ${ipackage%/*}*
done
# 
# docker pull harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis
# docker pull harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis
# docker tag harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis     harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
# docker tag harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis    harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
# docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
# docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
# docker save -o  cvat-b.tar harbor.apulis.cn:8443/release/apulistech/cvat-backend:v0.3.0-apulis
# docker save -o  cvat-f.tar harbor.apulis.cn:8443/release/apulistech/cvat-frontend:v0.3.0-apulis

# docker pull harbor.apulis.cn:8443/release/apulistech/ipc-upload-server/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/ipc-consumer-server/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/ipc-management-server/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/dataset-manager-api-server/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/dataset-worker-maker-mq/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/dataset-worker-publisher-cv/amd64:v0.1.0
# docker pull harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis
# docker pull harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis
# docker pull harbor.apulis.cn:8443/release/apulistech/aiarts-frontend/amd64:v3.0.0-songshanhu