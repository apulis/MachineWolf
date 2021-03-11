#! /bin/sh 
# filename STRESS_POD_USAGE.sh

# Test netbands for each npu chips in Tow NPU server
# Editor: Thomas
# Date: 2021-03-11 
# analysis tools: hccn_tool

# 测试步骤：
# 1. 在2台NPU服务器上都安装好相同的NPU Driver, 安装过程包含hccn_tool
# 2. 确保2台NPU服务器参数面网络都是通过100G交换机联通的
# 3. 配置NPU IP
## 以root用户登录到AI Server(atlas服务器)配置每个device的网卡IP。配置要求：
##
##  + AI Server中的第0/4，1/5，2/6，3/7号网卡需处于同一网段，第0/1/2/3号网卡在不同网段，第4/5/6/7号网卡在不同网段。
##  + 对于集群场景，各AI Server对应的位置的device需处于同一网段，例如AI Server1和AI Server2的0号网卡需处于同一网段，AI Server1和AI Server2的1号网卡需处于同一网段。
##
##  * 以下是第一台atlas服务器中NPU设备的IP配置
##
##  ```bash
##  hccn_tool -i 0 -ip -s address 192.168.10.11 netmask 255.255.255.0
##  hccn_tool -i 1 -ip -s address 192.168.20.12 netmask 255.255.255.0
##  hccn_tool -i 2 -ip -s address 192.168.30.13 netmask 255.255.255.0
##  hccn_tool -i 3 -ip -s address 192.168.40.14 netmask 255.255.255.0
##  hccn_tool -i 4 -ip -s address 192.168.10.15 netmask 255.255.255.0
##  hccn_tool -i 5 -ip -s address 192.168.20.16 netmask 255.255.255.0
##  hccn_tool -i 6 -ip -s address 192.168.30.17 netmask 255.255.255.0
##  hccn_tool -i 7 -ip -s address 192.168.40.18 netmask 255.255.255.0
##  ```
##
##  * 如果集群中有第二台 atlas服务器，其NPU设备的IP配置如下（示例）
##
##  ```bash
##  hccn_tool -i 0 -ip -s address 192.168.10.21 netmask 255.255.255.0
##  hccn_tool -i 1 -ip -s address 192.168.20.22 netmask 255.255.255.0
##  hccn_tool -i 2 -ip -s address 192.168.30.23 netmask 255.255.255.0
##  hccn_tool -i 3 -ip -s address 192.168.40.24 netmask 255.255.255.0
##  hccn_tool -i 4 -ip -s address 192.168.10.25 netmask 255.255.255.0
##  hccn_tool -i 5 -ip -s address 192.168.20.26 netmask 255.255.255.0
##  hccn_tool -i 6 -ip -s address 192.168.30.27 netmask 255.255.255.0
##  hccn_tool -i 7 -ip -s address 192.168.40.28 netmask 255.255.255.0
# 4. 设计测试案例并执行测试脚本
## 假设测试脚本执行在第一台服务器上，对端在第二台服务器上
## 4.1. 测试第0个ib网卡读取数据带宽：ib_read_bw
## 其中 -s 是传输网络包的大小，默认设置4096字节；-n 循环测试10次；address指定对端的NPU卡IP；-d 指定ib设备，默认为hns0
hccn_tool -i 0 -roce_test ib_read_bw -d hns0 -s 4096 -n 10                       # device01
hccn_tool -i 0 -roce_test ib_read_bw -d hns0 -s 4096 -n 10 address 192.168.1.21  # device02

# 也可以通过脚本遍历
# npuchips=(0 1 2 3 4 5 6 7)
# testip=(192.168.10.21 192.168.20.22 192.168.30.23 192.168.40.24 192.168.10.25 192.168.20.26 192.168.30.27 192.168.40.28)
# for i in ${npuchips[@]};
# do 
# hccn_tool -i $i -roce_test ib_read_bw -d hns0 -s 4096 -n 10 address 192.168.1.21
# done

## 4.2. 测试第0个ib网卡读取数据时延：ib_read_lat
hccn_tool -i 0 -roce_test ib_read_lat -d hns0 -s 4096 -n 10                       # device01
hccn_tool -i 0 -roce_test ib_read_lat -d hns0 -s 4096 -n 10 address 192.168.1.21  # device02

## 4.3. 测试第0个ib网卡发送数据带宽：ib_send_bw
hccn_tool -i 0 -roce_test ib_send_bw -d hns0 -s 4096 -n 10                        # device01
hccn_tool -i 0 -roce_test ib_send_bw -d hns0 -s 4096 -n 10 address 192.168.1.21   # device02

## 4.4. 测试第0个ib网卡发送数据时延：ib_send_lat
hccn_tool -i 0 -roce_test ib_send_lat -d hns0 -s 4096 -n 10                       # device01
hccn_tool -i 0 -roce_test ib_send_lat -d hns0 -s 4096 -n 10 address 192.168.1.21  # device02

## 4.5. 测试第0个ib网卡写入数据带宽：ib_write_bw
hccn_tool -i 0 -roce_test ib_write_bw -d hns0 -s 4096 -n 10                       # device01
hccn_tool -i 0 -roce_test ib_write_bw -d hns0 -s 4096 -n 10 address 192.168.1.21  # device02

## 4.6. 测试第0个ib网卡写入数据时延：ib_write_lat
hccn_tool -i 0 -roce_test ib_write_lat -d hns0 -s 4096 -n 10                      # device01
hccn_tool -i 0 -roce_test ib_write_lat -d hns0 -s 4096 -n 10 address 192.168.1.21 # device02
