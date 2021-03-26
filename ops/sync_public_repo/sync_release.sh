#！/bin/bash

# 同步 Apulis Platform 
version=v1.5.0

# Apulis Platform
echo "========================="Sync Apulis Platform"========================="
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/DLWorkspace.git
cd DLWorkspace
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/apulis_platform.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/apulis_platform.git
git push github
git push gitee
cd ..

echo "========================="Sync user-dashboard-frontend"========================="
# user-dashboard-frontend
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/addon_custom_user_group_dashboard.git
cd addon_custom_user_group_dashboard
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/user-dashboard-frontend.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/user-dashboard-frontend.git
git push github
git push gitee
cd ..

echo "========================="user-dashboard-backend"========================="
# user-dashboard-backend
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/addon_custom_user_dashboard_backend.git
cd addon_custom_user_dashboard_backend
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/user-dashboard-backend.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/user-dashboard-backend.git
git pull
git push github
git push gitee
cd ..

echo "========================="Arts-Frontend"========================="
# AIArts-Frontend
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/AIArts.git
cd AIArts
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/AIArts-Frontend.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/aiarts-frontend.git
git pull
git push github
git push gitee
cd ..

echo "========================="ArtsBackend"========================="
# AIArtsBackend
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/AIArtsBackend.git
cd AIArtsBackend
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/AIArts-Backend.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/aiarts-backend.git
git pull
git remote -v
git push github
git push gitee
cd ..

echo "========================="Sync image-label-frontend"========================="
# image-label-frontend
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/NewObjectLabel.git
cd NewObjectLabel
git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/image-label-frontend.git
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/image-label-frontend.git
git pull
git remote -v
git push github
git push gitee
cd ..

# image-label-backend 无更新
# git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/data-platform-backend.git
# cd data-platform-backend
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/image-label-backend.git
# git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/image-label-backend.git
# git push github
# git push gitee
# cd ..

# ascend-for-volcano 无更新
# git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/ascend-for-volcano.git
# cd ascend-for-volcano
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/ascend-for-volcano.git
# git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/ascend-for-volcano.git
# git push github
# git push gitee
# cd ..

# ascend-device-plugin 无更新
# git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/ascend-device-plugin.git
# cd ascend-device-plugin
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/ascend-device-plugin.git
# git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/ascend-device-plugin.git
# git push github
# git push gitee
# cd ..

# k8s-device-plugin
git clone -b master https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/k8s-device-plugin.git
cd k8s-device-plugin
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/k8s-device-plugin.git  无权限push
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/k8s-device-plugin.git
git push github
git push gitee
cd ..

# kfserving 无更新
# git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/kfserving.git
# cd kfserving
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/kfserving.git
# git remote add gitee https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/kfserving.git
# git push github
# git push gitee
# cd ..

# InstallationYTung 
git clone -b $version https://<HOSTNAME>:<PASSWORLD>@apulis-gitlab.apulis.cn/apulis/InstallationYTung.git
cd InstallationYTung
# git remote add github https://<HOST>:<PASSWORD>@github.com/apulis/InstallationYTung.git 无权限push
git remote add gitee  https://<HOST>:<PASSWORD>@gitee.com/apulisplatform/installation-ytung.git
git push github
git push gitee
cd ..

