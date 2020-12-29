#!/bin/bash

#=========================================================================================================================
# 多线程同步和编译镜像 
# Creator: thomas
# Date: 2020-12-24
# Tool version: 0.1.0
# Software: Apulis Platform
#=========================================================================================================================

# 待升级集群master主机IP, 账号
update_host=119.147.212.162
update_host_port=50018
update_host_name=root
update_host_passwd=Aiops@18c
update_host_deployment_path=/home/dlwsadmin/DLWorkspace/YTung/src/ClusterBootstrap

platform_compile=$HOME/platform_compile
images_save=$HOME/images_save

# 同步最新代码版本号
update_version=v1.3.0
# 创建repo录: platform_compile
mkdir -p $platform_compile
# 创建镜像保存目录: images_save
mkdir -p $images_save
# 需要同步的模块
models=("AIArts" "AIArtsBackend" "addon_custom_user_group_dashboard" "addon_custom_user_dashboard_backend" "webui3" "restfulapi2" "init-container"  "job-exporter"  "gpu-reporter" "watchdog"  "repairmanager2" "image-label-backend" "image-label-frontend")
# 需要更新的代码库,其中NewObjectLabel没有同步更新
repos=("AIArts" "AIArtsBackend" "addon_custom_user_group_dashboard" "addon_custom_user_dashboard_backend" "DLWorkspace")

for repo in ${A[@]};
do
{   
    git clone -b $update_version https://haiyuan.bian:apulis18c@apulis-gitlab.apulis.cn/apulis/$repo.git 
    echo "sleep 5"
    sleep 5
} &
done
wait

# 进入具体repo编译镜像
cd $platform_compile
for repo in ${models[@]};
do
{ 
    if [[ $repo == "AIArts" ];then

        echo "Start building $repo ..."  
        cd AIArts && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0
        cd $images_save && docker save -o dlworkspace_aiarts-frontend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0
        cd ..
        echo "$repo has builded finished ! "  
        
    elif [[ $repo == "AIArtsBackend" ];then

        echo "Start building $repo ..."  
        cd AIArtsBackend && docker build -f deployment/Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
        cd $images_save && docker save -o dlworkspace_aiarts-backend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
        cd ..
        echo "$repo has builded finished ! "  

    elif [[ $repo == "addon_custom_user_group_dashboard" ];then

        echo "Start building $repo ..."  
        cd addon_custom_user_group_dashboard && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
        cd $images_save && docker save -o addon_custom_user_group_dashboard.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
        cd ..
        echo "$repo has builded finished ! "  

    elif [[ $repo == "addon_custom_user_dashboard_backend" ];then

        echo "Start building $repo ..."  
        cd addon_custom_user_group_dashboard && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
        cd $images_save && docker save -o addon_custom_user_dashboard_backend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
        cd ..
        echo "$repo has builded finished ! "  

    # Build in DLWSpace Repo

    # elif [[ $repo == "restfulapi2" ];then
    #    restfulapi2 编译脚本需要更新
    #    echo "Start building $repo ..."  
    #    cd DLWorkspace && cd src/ClusterBootstrap/build/ && cp ./build.sh ./build_update.sh && bash ./build_update.sh <tag name> <branch name> <remote_machine=(192.168.1.200 22)>
    #    cd ../images_save && docker save -o dlworkspace_aiarts-backend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
    #    cd ..
    #    echo "$repo has builded finished ! "  
    #elif [[ $repo == "webui3" ];then
    #
    #    echo "Start building $repo ..."  
    #    cd DLWorkspace/src/ClusterBootstrap/ && ./deploy.py --verbose webui
    #    ./deploy.py docker build webui3
    #    docker tag　dlworkspace_webui3:latest  harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_webui3:latest
    #    cd ../images_save && docker save -o dlworkspace_webui3.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_webui3:latest
    #    cd ..
    #    echo "$repo has builded finished ! "  
    #sleep 5
    fi
} &
done
wait

# 同步代码到远程主机
sshpass -p "Aiops@18c" rsync  --rsh='ssh -p 50018 ' -avz -P $images_save root@119.147.212.162:/tmp/ 

# sshpass -p "Aiops@18c" scp -P 50018  ./addon_custom_user_dashboard_backend.tar root@119.147.212.162:/tmp/ 
harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_restfulapi2:latest
# 加载新镜像
sshpass -p "Aiops@18c" ssh -p 50018 root@119.147.212.162
cd /tmp/deployment/ 
for fileName  in ` ls $1 `
    do 
    docker load -i $fileName
    #　docker push loaded_name
done
 
cd $update_host_deployment_path && ./deploy.py kubernetes stop aiarts-frontend aiarts-backend  custom-user-dashboard # webui3
echo "Wait 15s For stop old pod! " && sleep 15s
./deploy.py kubernetes start aiarts-frontend aiarts-backend  custom-user-dashboard # webui3
# 重启服务
sshpass -p "Aiops@18c" rsync -az '-e ssh -p 50018 '  -P  root@119.147.212.162:/tmp/ $images_save

sshpass -p "Aiops@18c" rsync  --rsh='ssh -p 50018 ' -az -P  $images_save root@119.147.212.162:/tmp/

docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0