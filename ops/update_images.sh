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