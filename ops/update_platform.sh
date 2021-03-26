#!/bin/bash

#=========================================================================================================================
# Info: 按版本更新平台
# Creator: thomas
# Update: 2020-12-24
# Tool version: 0.1.0
# Support Platform Version: Apulis AI Platform v2.0.0
#=========================================================================================================================


# 待升级集群master主机IP, 账号
update_host=192.168.1.198
update_host_port=22
update_host_name=<HOSTNAME>
update_host_passwd=<PASSWORLD>
update_host_deployment_path=/home/

platform_compile=$HOME/platform_compile
images_save=$HOME/images_save
remote_images_path=/tmp/
update_date=`date +%s`
# Update Installation tools

cd $update_host_deployment_path
mv InstallationYTung InstallationYTung_bat_$update_date
git clone -b v2.0.0  https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/InstallationYTung.git
cd InstallationYTung
# 同步最新代码版本号
update_version=v2.0.0
update_tag=""
# 创建repo更新目录: platform_compile
mkdir -p $platform_compile
# 创建镜像保存目录: images_save
mkdir -p $images_save
# 需要同步的模块
models=("AIArts" "AIArtsBackend" "addon_custom_user_group_dashboard" "addon_custom_user_dashboard_backend" "webui3" "restfulapi2" "init-container"  "job-exporter"  "gpu-reporter" "watchdog"  "repairmanager2" "image-label-backend" "image-label-frontend")
# 需要更新的代码库,其中NewObjectLabel没有同步更新
repos=("AIArts" "AIArtsBackend" "addon_custom_user_group_dashboard" "addon_custom_user_dashboard_backend" "DLWorkspace")


cd $platform_compile


for repo in ${repos[@]};
do
{   
    git clone -b $update_version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/$repo.git 
} &
done
wait

# 进入具体repo编译镜像

for imode in ${models[@]};
do
{ 
    if [ $imode = "AIArts" ]; then

        cd AIArts && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0
        cd $images_save && docker save -o dlworkspace_aiarts-frontend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0
        cd ..
        echo "$imode has builded finished ! "  
        
    elif [ $imode = "AIArtsBackend" ]; then

        cd AIArtsBackend && docker build -f deployment/Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
        cd $images_save && docker save -o dlworkspace_aiarts-backend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
        cd ..
        echo "$imode has builded finished ! "  

    elif [ $imode = "addon_custom_user_group_dashboard" ]; then

        cd addon_custom_user_group_dashboard && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
        cd $images_save && docker save -o addon_custom_user_group_dashboard.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
        cd ..
        echo "$imode has builded finished ! "  

    elif [ $imode = "addon_custom_user_dashboard_backend" ]; then

        cd addon_custom_user_group_dashboard && docker build -f Dockerfile . -t harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
        cd $images_save && docker save -o addon_custom_user_dashboard_backend.tar harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
        cd ..
        echo "$imode has builded finished ! "  

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
sshpass -p "<PASSWORLD>" rsync  --rsh='ssh -p 50018 ' -avz -P $images_save root@119.147.212.162:/tmp/ 

# 加载新镜像
load_and_update(){
sshpass -p "<PASSWORLD>" ssh -p <PORT> root@<LINKADDRESS>  > /dev/null 2>&1 << eeooff
cd $1 
for fileName  in ` ls $1 `
    do 
    docker load -i $fileName
    RESULT=$(docker load -i $fileName)
    IMAGE=${RESULT#*: }
    docker push $IMAGE
done
 
cd $2 && ./deploy.py kubernetes stop aiarts-frontend aiarts-backend  custom-user-dashboard 
# webui3
echo "Wait 15s For stop old pod! " && sleep 15s

# 重启服务
./deploy.py kubernetes start aiarts-frontend aiarts-backend  custom-user-dashboard 
# webui3
eeooff
}

load_and_update $remote_images_path/images_save $update_host_deployment_path

# sshpass -p "<PASSWORLD>" rsync -az '-e ssh -p 50018 '  -P  root@119.147.212.162:/tmp/ $images_save
# sshpass -p "<PASSWORLD>" rsync  --rsh='ssh -p 50018 ' -az -P  $images_save root@119.147.212.162:/tmp/
# sshpass -p "<PASSWORLD>" scp -P 50018  ./addon_custom_user_dashboard_backend.tar root@119.147.212.162:/tmp/ 
# harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_restfulapi2:latest
# 
# ./deploy.py kubernetes stop  custom-user-dashboard
# ./deploy.py kubernetes start  custom-user-dashboard 
# docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-backend:latest
# docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_custom-user-dashboard-frontend:latest
# docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-backend:1.0
# docker push harbor.sigsus.cn:8443/sz_gongdianju/apulistech/dlworkspace_aiarts-frontend:1.0.0