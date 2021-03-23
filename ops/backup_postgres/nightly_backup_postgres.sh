#!/bin/bash

# Info: Nightly backup or restore all databases of postgres in cluster
# Editor: Thomas
# Date: 2021-03-22 
# Suggestion: Please start as services at master node or another None-Worker node!
# Postgres_Version: 11.10
# Script_Version: 0.1

set_env()
{
# 初始化设置环境
echo "================== set-env done! "
HOST=192.168.1.198
PORT=5432
USERNAME=postgres
PGPASSWORD="ff20ncd9bc72k3cF"
DATABASENAME=postgres
BACKUPFILENAME=/mnt/hdd/pvc/aiplatform-model-data/
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-client-11
}

backup_dbs()
{
datetime=`date "+%H-%M-%S-%d-%m-%y"`
NIGHTLYBACKUPDIR=$BACKUPFILENAME/$datetime
mkdir -p  $NIGHTLYBACKUPDIR
dbsets=`echo "SELECT datname FROM pg_database;" | PGPASSWORD=$PGPASSWORD  psql -h $HOST -p $PORT -U $USERNAME | tail -n +3 | head -n -2 | egrep -v 'template0|template1|postgres'`
for idb in $dbsets
do
touch NIGHTLYBACKUPDIR/$idb
echo "================== NightlyBackUp: $NIGHTLYBACKUPDIR/$idb  "
PGPASSWORD=$PGPASSWORD pg_dump --host $HOST --port $PORT --username $USERNAME -b -c -E UTF-8 --no-owner --no-privileges --no-tablespaces --clean --schema public -F c -Z 9 -f $NIGHTLYBACKUPDIR/$idb $idb
done
}


restore_dbs()
{
for file in `ls $BACKUPFILENAME` 
do 
echo "================== Restore: $BACKUPFILENAME/$file  "
PGPASSWORD=$PGPASSWORD pg_restore --host $HOST --port $PORT --username $USERNAME --dbname $file --no-owner --no-privileges --no-tablespaces --clean --schema public $BACKUPFILENAME/$file
done
}

# 向系统添加每晚12:00定时执行任务
set_crontab()
{
echo "================== set-crontab sechdule done! "
chmod +w /etc/crontab
# 测试使用每5min备份一次
# echo  "*/5 * * * * root bash /home/InstallationYTung/nightly_backup_postgres.sh -h $HOST -p $PORT -u $USERNAME -w $PGPASSWORD -t backup -d $BACKUPFILENAME  >> /var/log/backup-dbs.log" >> /etc/crontab
echo  "59 23 * * * root bash /home/InstallationYTung/nightly_backup_postgres.sh -h $HOST -p $PORT -u $USERNAME -w $PGPASSWORD -t backup -d $BACKUPFILENAME  >> /var/log/backup-dbs.log" >> /etc/crontab
chmod -w /etc/crontab
service cron restart
}

help_example()
{
echo """
# 脚本使用说明：
# 1. 支持传参备份数据库，可单独执行，示例如下：
#    Backup example: ./sechdule_backup_postgres.sh -h 192.168.1.198 -p 5432 -u postgres -w ff20ncd9bc72k3cF -t backup -d /tmp
# 2. 支持传参备份数据库，可单独执行，需制定具体的某次备份的目录，示例如下：
#    Restore example: ./sechdule_backup_postgres.sh -h 192.168.1.198 -p 5432 -u postgres -w ff20ncd9bc72k3cF -t restore -d /tmp/00-20-01-23-03-21
# 3. 支持添加到系统计划任务中
#    Cron example: ./sechdule_backup_postgres.sh -h 192.168.1.198 -p 5432 -u postgres -w ff20ncd9bc72k3cF -t crontab -d /tmp/
# Options:
# -h 主机IP
# -p DB的端口
# -u DB的用户名
# -w DB的登录密码
# -t 任务：backup 或 restore 或 crontab
# -d 备份目录，backup会创建以时间为名称的目录，restore会拿时间为名称的目录下的备份恢复数据库
# -? 输出help信息
# example: ./sechdule_backup_postgres.sh -h 192.168.1.198 -p 5432 -u postgres -w ff20ncd9bc72k3cF -t backup -d /tmp
"""
}

# set_env  
while getopts "h:p:u:w:t:d:?" options; do
    case "${options}" in
        h) 
          HOST=${OPTARG};;
        p) 
          PORT=${OPTARG};;
        u) 
          USERNAME=${OPTARG};;
        w) 
          PGPASSWORD=${OPTARG};;
        t) 
          TASK=${OPTARG};;
        d) 
          BACKUPFILENAME=${OPTARG};;
        :)                                   
          echo "Error: -${OPTARG} requires an argument."
          exit_abnormal                       
          ;;
        ?) 
          help_example;;
    esac
done
if [ "backup" == "$TASK" ];
then  
backup_dbs
elif [ "restore" == "$TASK" ];
then  
restore_dbs  
elif [ "crontab" == "$TASK" ];
then  
set_crontab
fi 
