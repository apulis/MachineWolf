#/bin/bash

#设置docker代理

# you should set it to your proxy ip 
proxy_ip="http://192.168.246.1:1080"
# you need set it to the  host ip 
proxy_none_ip="192.168.0.0/16"   

proxy='Environment="HTTPS_PROXY='${proxy_ip}'"\
Environment="NO_PROXY=127.0.0.0/8"\
Environment="NO_PROXY='${proxy_none_ip}'"'
DOCKER_CONF="/usr/lib/systemd/system/docker.service"
#DOCKER_CONF="docker.service"
if [ ! -e $DOCKER_CONF ]; then 
    echo "INFO: docker not running "
    exit 2
fi
func_reload(){
    systemctl daemon-reload
    systemctl restart docker
    echo "INFO#: docker-reload finined!"
}
func_proxy_on(){
    if grep PROXY $DOCKER_CONF >> /dev/null ; then
        echo "INFO#: docker proxy may be on : "
        echo ""
        grep PROXY $DOCKER_CONF
        echo ""
    else
        echo "INFO: docker proxy on"
        sed -i "/ExecStart/i${proxy}" $DOCKER_CONF
        func_reload
    fi
}

func_proxy_off(){
    if grep PROXY $DOCKER_CONF >>/dev/null; then
            echo "INFO: docker proxy off"
        sed -i "/PROXY/d" $DOCKER_CONF
        func_reload
    else
            echo "INFO: docker proxy already off"
    fi
}

case $1 in
    on)
      func_proxy_on
      ;;
    off)
      func_proxy_off
      ;;
    *) 
      echo "userage `basename $0` {on|off}"
      exit 1
      ;;
esac