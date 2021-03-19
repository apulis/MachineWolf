# DockerName: Locust runner
# Usecase: With locust runtime dependentance tools and testsuites
# Update: 2021-03-14
# Dependents:  python3
# Arch: x86-64
# Version: v0.5.0
# Editor：thomas
# Build In China

ARG PYTHON="3.7.5"
FROM opensuse/leap:15.2
ENV PYTHONUNBUFFERED=1
WORKDIR /hoem/workspace

RUN mkdir /etc/zypp/repos.d/repo_bak && mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo_bak/  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/     NON-OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/         OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/                UPDATE-NON-OSS    \              
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/                    UPDATE-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/non-oss       openSUSE-Aliyun-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/oss           openSUSE-Aliyun-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/non-oss                  openSUSE-Aliyun-UPDATE-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/oss                      openSUSE-Aliyun-UPDATE-OSS  \
    && zypper -q ref   \  
    && zypper update -y && zypper install -y git sudo python3 vim curl  wget  python3-devel  \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
    && python3 get-pip.py   \
    && pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple   

# 同步测试库
RUN git clone -b develop https://haiyuan.bian:apulis18c@apulis-gitlab.apulis.cn/apulis/PerfBoard.git   \
    && cd PerfBoard \
    && pip3 install -U -r requirements.ini
# Build  example
# docker build -f Dockerfile . -t  harbor.apulis.cn:8443/testops/locust-suse-basement:latest
# Run example
# docker run -it -p 8089:8089 -v $PWD:/mnt/locust locustio/locust -f /mnt/locust/example/test_http.py bash