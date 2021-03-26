!/bin/bash

#=========================================================================================================================
# Info: 导入到训练镜像并插入数据库
# Creator: thomas
# Update: 2021-03-24 
# Tool version: 0.1.0
# Support Platform Version: Apulis AI Platform v2.0.0
#=========================================================================================================================

# Init dev
sudo apt-get update && sudo apt-get install -y postgresql-client

# Database Info
dbName="postgres"
netMaxSpeeds=500
DB_ADDRESS="192.168.1.198" 
DB_PORT=5432
DATABASE_NAME="ai_arts" 
USER="postgres" 
PGPASSWORD="ff20ncd9bc72k3cF" 
DATABASE_ENGINE=postgres

# Add postgres password file
echo "${DB_ADDRESS}:${DB_PORT}:${DATABASE_NAME}:${USER}:${PGPASSWORD}" > ~/.pgpass
models=("pytorch:1.5" "mxnet:2.0.0-gpu-py3" "tensorflow:2.3.0-gpu-py3" "tensorflow:1.15.2-gpu-py3" "tensorflow:1.14.0-gpu-py3")
localHarbor=harbor.atlas.cn:8443/sz_gongdianju
for imodel in ${models}
do
docker pull harbor.apulis.cn:8443/algorithm/apulistech/$imodel
docker tag harbor.apulis.cn:8443/algorithm/apulistech/$imodel   $localHarbor/apulistech/$imodel
docker push $localHarbor/apulistech/$imodel
# Insert new train models image
PGPASSWORD=$PGPASSWORD psql -U ${USER} -h ${DB_ADDRESS} -d ${DATABASE_NAME} << EOF
    insert into images (image_type, image_full_name, details) values ('${imodel%:*}', 'apulistech/${imodel}', '{"desc":"描述信息","category":"normal","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
EOF
done

rm ~/.pgpass

# * 镜像列表插入选择和删除
# ```sql
# insert into images (image_type, image_full_name, details) values ('mindspore', 'apulistech/mindspore:1.1.0', '{"desc":"描述信息","category":"normal","brand":"nvidia","cpuArchType":"amd64","deviceType":"gpu"}');
# select * from public.images;
# delete from public.images where image_full_name like '%npu%';
# ```
