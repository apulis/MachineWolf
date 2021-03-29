# !/bin/bash
# Init MachineWolf  development environment
# Matainer: Thome
# UpdateTime: 2021-03-08
# License: Mozilla

# Install dependants
py3version=$(python3 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [[ -z "$py3version" ]]
then
    echo "No Python!" 
fi
python3 --version 
parsedVersion=$(echo "${py3version//./}")

if [[ "$parsedVersion" -gt "3600" && "$parsedVersion" -gt "270" ]]
then 
    echo "Valid Python Version"
else
    echo "Invalid Python Version"
fi

# Install and active env

mkdir /etc/zypp/repos.d/repo_bak && mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo_bak/  
zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/     NON-OSS  
zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/         OSS  
zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/                UPDATE-NON-OSS                 
zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/                    UPDATE-OSS  
zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/non-oss       openSUSE-Aliyun-NON-OSS  
zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/oss           openSUSE-Aliyun-OSS  
zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/non-oss                  openSUSE-Aliyun-UPDATE-NON-OSS  
zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/oss                      openSUSE-Aliyun-UPDATE-OSS  
zypper -q ref     
zypper update -y && zypper install -y git sudo python3 vim curl  wget  python3-devel 
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  
python3 get-pip.py   
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple   
python3 -m pip install -U virtualenv
virtualenv env
sudo chmod +x ./env/bin/activate
source ./env/bin/activate
pip install -U -r requirements.ini
# python3 -c 'import sys; print(sys.version_info)'
