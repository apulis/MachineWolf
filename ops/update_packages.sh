#!/bin/bash

#=========================================================================================================================
# Info: 批量更新镜像
# Creator: thomas
# Update: 2021-03-16
# Tool version: 0.1.0
# Support Platform Version: Apulis AI Platform v2.0.0
#=========================================================================================================================

local_harbor_passwd=`cat credentials/harbor.pwd`
public_hub="harbor.apulis.cn:8443"
public_project="release/apulistech"
local_hub="harbor.atlas.cn:8443"
local_project="apulis/apulistech"
package_list=( "aiarts-frontend/amd64:v3.0.0-songshanhu"  \
                "dataset-worker-publisher-cv/amd64:v0.1.0"  \  
                "dataset-worker-maker-mq/amd64:v0.1.0"  \  
                "dataset-manager-api-server/amd64:v0.1.0"  \  
                "cvat-backend/amd64:v0.3.0-apulis"  \
                "cvat-frontend/amd64:v0.3.0-apulis"  \ 
                "ipc-upload-server/amd64:v0.1.0"  \  
                "ipc-consumer-server/amd64:v0.1.0"  \  
                "ipc-management-server/amd64:v0.1.0"  )
update_version="v3.0.0"
update_tag=""
kube_namespace="default"

docker logout
docker login -u admin -p $local_harbor_passwd $local_hub
for ipackage in ${package_list[@]}
do

docker pull ${public_hub}/${public_project}/${ipackage}
local_right_image=${ipackage#*:}
local_left_image=${ipackage%/*}
echo "=========================: "    ${local_hub}/${local_project}/${local_left_image}:${local_right_image}
docker tag ${public_hub}/${public_project}/${ipackage}   ${local_hub}/${local_project}/${local_left_image}:${local_right_image}
docker push ${local_hub}/${local_project}/${local_left_image}:${local_right_image}
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