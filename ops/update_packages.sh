#!/bin/bash

#=========================================================================================================================
# Info: 批量更新镜像
# Creator: thomas
# Update: 2021-03-16
# Tool version: 0.1.0
# Support Platform Version: Apulis AI Platform v2.0.0
#=========================================================================================================================

public_hub="harbor.apulis.cn:8443"
public_project="release/apulistech"
local_hub="harbor.apulis.cn:8443"
local_project="sz_gongdianju/apulistech"
package_list=( cvat-backend/amd64:v0.3.0-apulis cvat-frontend/amd64:v0.3.0-apulis)
update_version="v2.0.0"
update_tag=""
kube_namespace="default"

for ipackage in ${package_list}
do

docker pull ${public_hub}/${public_project}/${ipackage}
local_right_image=${ipackage#*/}
local_left_image=${ipackage%/*}
docker tag ${public_hub}/${public_project}/${ipackage}   ${local_hub}/${local_project}/${local_left_image}:${iplocal_right_imageackage}

docker push ${local_hub}/${local_project}/${local_left_image}:${iplocal_right_imageackage}
kubectl delete pod -n ${kube_namespace}  ${ipackage%/*}*
done

docker pull harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis
docker pull harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis
# docker tag harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis     harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
# docker tag harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis    harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
# docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
# docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
# docker save -o  cvat-b.tar harbor.apulis.cn:8443/release/apulistech/cvat-backend:v0.3.0-apulis
# docker save -o  cvat-f.tar harbor.apulis.cn:8443/release/apulistech/cvat-frontend:v0.3.0-apulis