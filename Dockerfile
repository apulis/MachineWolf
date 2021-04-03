# DockerName: Locust runner
# Usecase: With locust runtime dependentance tools and testsuites
# Update: 2021-03-30
# Dependents:  python3
# Arch: x86-64
# Version: v0.5.0
# Editor：thomas
# Build In China

FROM  mltooling/ml-workspace:0.12.1
ENV PYTHON_HOME  /usr/bin/python3

WORKDIR /home/

# 如果在国内环境，先下载go安装包
# COPY docker-build/go1.16.2.linux-amd64.tar.gz  .

RUN sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak  \
    && sudo sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list  \
    && sudo sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list  \
    && apt update    \ 
    && wget https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz   \  
    && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz   \
    && export PATH=$PATH:/usr/local/go/bin   \
    && go env -w GOPROXY=https://goproxy.cn,direct  \
    && pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple   \
    && pip config set install.trusted-host https://repo.huaweicloud.com  \
    && pip install python-dev-tools  \
    && git clone -b master https://haiyuan.bian:apulis18c@apulis-gitlab.apulis.cn/apulis/MachineWolf.git   \
    && cd /home/MachineWolf/  \
    && git pull origin master  \
    && pip install -U --ignore-installed -r /home/MachineWolf/requirements.ini \ 
    && bzt /home/MachineWolf/example/jmeter/trace_user_footprint.jmx  \
    && rm -rf /tmp/* 

# port
# EXPOSE 1099 8080 8088 8089

# Build  example
# docker build -f MachineWolf/Dockerfile .  -t  harbor.apulis.cn:8443/testops/machinewolf:latest
# docker push harbor.apulis.cn:8443/testops/machinewolf:latest
# Run example
# docker run -d     -p 8088:8080     --name "ml-workspace"  -v "${PWD}:/workspace"  --env NOTEBOOK_ARGS="--NotebookApp.notebook_dir=/home"   --shm-size 2048m     --restart always     harbor.apulis.cn:8443/testops/machinewolf:latest