!/bin/bash

# 进入指定的磁盘目录
cd /home/
# 创建 20G 大文件 testfile 占用磁盘
dd if=/dev/zero of=testfile bs=4M count=20000