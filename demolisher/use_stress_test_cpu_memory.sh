#! /bin/sh 
# filename STRESS_POD_USAGE.sh

# Test POD Max Usages: CPU,MEM,IO
# Editor: Thomas
# Date: 2021-01-30 
# 请在NPU worker节点执行 
# analysis tools: perf  


# Install tools
sudo apt-get update && sudo apt-get install -y stress nmon linux-tools-common linux-tools-generic linux-tools-`uname -r`
# counts cpu cores， `nproc` ，`grep -Pc '^processor\t' /proc/cpuinfo`
echo "TOTAL CPU CORES: "
cat /proc/cpuinfo | grep processor | wc -l
# count mem size
echo "TOTAL MEM SIZE: "
free -m

uptime 
# stress http://manpages.ubuntu.com/manpages/bionic/man1/stress.1.html
stress --cpu 190 --io 190 --vm 750 --vm-bytes 1024M -d 750 --vm-keep --timeout 3600s 
uptime

# Or Use tload -s 750 -d 750
# refer https://www.cyberciti.biz/tips/graphic-representation-system-load-average-linux.html

# matrix 
# htop