#!/bin/bash

#=========================================================================================================================
# 批量更新镜像tag
# Creator: thomas
# Date: 2021-03-16
# Tool version: 0.1.0
# Software: Apulis AI Platform
#=========================================================================================================================

remote_hub_project="harbor.apulis.cn:8443/release"
remote_list=(user_fronted:v1.6.0 
user_backend:v1.6.0 
aiarts-frontend:v2.0.0 
mlflow:v1.0.0 
dlworkspace-restfulapi2:v2.0.0
dlworkspace-webui3:v2.0.0
cvat-backend:v0.3.0-apulis
cvat-frontend:v0.3.0-apulis
aiarts-backend:v2.0.0)
local_hub_project="harbor.apulis.cn:8443/release"
update_version="v2.0.0"
update_tag=""

for repo in ${repos[@]};
do
{

}

docker pull harbor.apulis.cn:8443/release/apulistech/user_fronted/amd64:v1.6.0
docker pull harbor.apulis.cn:8443/release/apulistech/user_backend/amd64:v1.6.0
docker pull harbor.apulis.cn:8443/release/apulistech/aiarts-frontend/amd64:v2.0.0
docker pull harbor.apulis.cn:8443/release/apulistech/mlflow/amd64:v1.0.0
docker pull harbor.apulis.cn:8443/release/apulistech/dlworkspace-restfulapi2/amd64:v2.0.0
docker pull harbor.apulis.cn:8443/release/apulistech/dlworkspace-webui3/amd64:v2.0.0
docker pull harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis
docker pull harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis
docker pull harbor.apulis.cn:8443/release/apulistech/aiarts-backend/amd64:v2.0.0           



docker tag harbor.apulis.cn:8443/release/apulistech/user_fronted/amd64:v1.6.0            harbor.atlas.cn:8443/release/apulistech/custom-user-dashboard-frontend:v2.0.0
docker tag harbor.apulis.cn:8443/release/apulistech/user_backend/amd64:v1.6.0            harbor.apulis.cn:8443/release/apulistech/user_backend:v2.0.0
docker tag harbor.apulis.cn:8443/release/apulistech/aiarts-frontend/amd64:v2.0.0         harbor.atlas.cn:8443/sz_gongdianju/apulistech/aiarts-frontend:v2.0.0
docker tag harbor.apulis.cn:8443/release/apulistech/mlflow/amd64:v1.0.0                  harbor.atlas.cn:8443/sz_gongdianju/apulistech/mlflow:v1.0.0
docker tag harbor.apulis.cn:8443/release/apulistech/dlworkspace-restfulapi2/amd64:v2.0.0 harbor.atlas.cn:8443/sz_gongdianju/apulistech/dlworkspace-restfulapi2:v2.0.0
docker tag harbor.apulis.cn:8443/release/apulistech/dlworkspace-webui3/amd64:v2.0.0      harbor.atlas.cn:8443/sz_gongdianju/apulistech/dlworkspace-webui3:v2.0.0   
docker tag harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis     harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
docker tag harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis    harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
docker tag harbor.apulis.cn:8443/release/apulistech/aiarts-backend/amd64:v2.0.0          harbor.atlas.cn:8443/sz_gongdianju/apulistech/aiarts-backend:v2.0.0


docker push harbor.atlas.cn:8443/release/apulistech/custom-user-dashboard-frontend:v2.0.0
docker push harbor.apulis.cn:8443/release/apulistech/user_backend:v2.0.0
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/aiarts-frontend:v2.0.0
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/mlflow:v1.0.0
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/dlworkspace-restfulapi2:v2.0.0
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/dlworkspace-webui3:v2.0.0   
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v0.3.0-apulis
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v0.3.0-apulis
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/aiarts-backend:v2.0.0


docker save -o  user_f.tar harbor.apulis.cn:8443/release/apulistech/user_fronted:v1.6.0          
docker save -o  user_b.tar harbor.apulis.cn:8443/release/apulistech/user_backend:v1.6.0
docker save -o  aiarts.tar harbor.apulis.cn:8443/release/apulistech/aiarts-frontend:v2.0.0
docker save -o  mlflow.tar harbor.apulis.cn:8443/release/apulistech/mlflow:v1.0.0
docker save -o  dlwork.tar harbor.apulis.cn:8443/release/apulistech/dlworkspace-restfulapi2:v2.0.0
docker save -o  dlwork.tar harbor.apulis.cn:8443/release/apulistech/dlworkspace-webui3:v2.0.0
docker save -o  cvat-b.tar harbor.apulis.cn:8443/release/apulistech/cvat-backend:v0.3.0-apulis
docker save -o  cvat-f.tar harbor.apulis.cn:8443/release/apulistech/cvat-frontend:v0.3.0-apulis
docker save -o  aiarts.tar harbor.apulis.cn:8443/release/apulistech/aiarts-backend:v2.0.0

docker tag harbor.apulis.cn:8443/release/calico/cni:v3.17.1                 harbor.atlas.cn:8443/sz_gongdianju/calico/cni:v3.17.1
docker tag harbor.apulis.cn:8443/release/calico/kube-controllers:v3.17.1    harbor.atlas.cn:8443/sz_gongdianju/calico/kube-controllers:v3.17.1
docker tag harbor.apulis.cn:8443/release/calico/node:v3.17.1                harbor.atlas.cn:8443/sz_gongdianju/calico/node:v3.17.1
docker tag harbor.apulis.cn:8443/release/calico/pod2daemon-flexvol:v3.17.1  harbor.atlas.cn:8443/sz_gongdianju/calico/pod2daemon-flexvol:v3.17.1

docker push harbor.atlas.cn:8443/sz_gongdianju/calico/cni:v3.17.1
docker push harbor.atlas.cn:8443/sz_gongdianju/calico/kube-controllers:v3.17.1
docker push harbor.atlas.cn:8443/sz_gongdianju/calico/node:v3.17.1
docker push harbor.atlas.cn:8443/sz_gongdianju/calico/pod2daemon-flexvol:v3.17.1


docker tag harbor.apulis.cn:8443/release/apulistech/cvat-backend/amd64:v0.3.0-apulis     harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v1.6.0
docker tag harbor.apulis.cn:8443/release/apulistech/cvat-frontend/amd64:v0.3.0-apulis    harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v1.6.0

docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-backend:v1.6.0
docker push harbor.atlas.cn:8443/sz_gongdianju/apulistech/cvat-frontend:v1.6.0
