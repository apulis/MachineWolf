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
WORKDIR /home/workspace

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
    && zypper update -y && zypper install -y gcc cmake git sudo python3 vim curl  wget  python3-devel  \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
    && python3 get-pip.py   \
    && pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple   \
    && pip3 install python-dev-tools  

# 同步测试库
RUN git clone https://haiyuan.bian:apulis18c@apulis-gitlab.apulis.cn/apulis/PerfBoard.git   \
    && pip3 install -U -r PerfBoard/requirements.ini && pip3 install jupyterlab   \
    && jupyter lab --NotebookApp.token=''  
    # && nohup jupyter lab --NotebookApp.token='' --port 8008 --no-browser --ip=\"0.0.0.0\" --allow-root --NotebookApp.iopub_msg_rate_limit=1000000.0 --NotebookApp.iopub_data_rate_limit=100000000.0 --NotebookApp.notebook_dir=PerfBoard &
EXPOSE 8008
ENTRYPOINT ["jupyter lab", "--NotebookApp.token=''", "--port 8008", "--no-browser", "--ip=\'0.0.0.0\'", "--allow-root", "--NotebookApp.iopub_msg_rate_limit=1000000.0", "--NotebookApp.iopub_data_rate_limit=100000000.0", "--NotebookApp.notebook_dir=PerfBoard"]


# Build  example
# docker build -f Dockerfile . -t  harbor.apulis.cn:8443/testops/perfboard:latest
# docker push harbor.apulis.cn:8443/testops/perfboard:latest:latest
# Run example
# docker run -d -p 8008:8008  perfboard:latest