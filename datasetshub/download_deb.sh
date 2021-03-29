## Download Packages With Dependencies Locally In Ubuntu
# * 下载指定架构的包

# * 常用架构说明
#     + i386： 32位x86
#     + amd64：amd 64位
#     + arm64：arm架构64位

# 设置系统架构
sudo dpkg --add-architecture amd64

# 安装 apt-rdepends
sudo apt install apt-rdepends

# 创建单独的目录
mkdir -p /home/apt/postgresql-client-common

# 仅下载安装包
sudo apt-get install --download-only
sudo mv /var/cache/apt/archives/*   /home/apt/postgresql-client-common/

# 获取所有依赖
sudo apt-cache depends postgresql-client-common

# 下载所有依赖
for i in $(apt-cache depends postgresql-client-common:amd64 | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/); do sudo apt-get download $i 2>>errors.txt; done

# **参考**
# * [ostechnix](https://ostechnix.com/download-packages-dependencies-locally-ubuntu/)# Download Packages With Dependencies Locally In Ubuntu
# * 下载指定架构的包
# * 常用架构说明
#     + i386： 32位x86
#     + amd64：amd 64位
#     + arm64：arm架构64位

# 设置系统架构
sudo dpkg --add-architecture amd64

# 安装 apt-rdepends
sudo apt install apt-rdepends

# 创建单独的目录
mkdir -p /home/apt/postgresql-client-common

# 仅下载安装包
sudo apt-get install --download-only
sudo mv /var/cache/apt/archives/*   /home/apt/postgresql-client-common/

# 获取所有依赖
sudo apt-cache depends postgresql-client-common

# 下载所有依赖
for i in $(apt-cache depends postgresql-client-common:amd64 | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/); do sudo apt-get download $i 2>>errors.txt; done

# 本地安装
# dpkg -i *.deb
# **参考**
# * [ostechnix](https://ostechnix.com/download-packages-dependencies-locally-ubuntu/)