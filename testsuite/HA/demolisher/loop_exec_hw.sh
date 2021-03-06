
#!/bin/bash
while true; do

. testtf_115/bin/activate

cd /mntdlws/storage/Resnet50_HC
./run_8p.sh

sleep 15m
ps -ef |grep python3.7 |awk '{print $2}'|xargs kill -9

# 类似ctrl-c
# kill -SIGINT $pid 或者 kill -2 $pid
done
#kill -SIGINT $pid 

