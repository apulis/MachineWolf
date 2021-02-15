# 添加docker用户组，一般已存在，不需要执行
sudo groupadd docker     
# 将登陆用户加入到docker用户组中
sudo gpasswd -a $USER docker
# 更新用户组
newgrp docker   
# 测试docker命令是否可以使用sudo正常使用
docker version  