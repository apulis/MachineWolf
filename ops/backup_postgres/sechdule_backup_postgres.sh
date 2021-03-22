#! /bin/sh 
# Info: Nightly backup and restore all databases of postgres in cluster
# Editor: Thomas
# Date: 2021-03-22 
# Suggestion: Please start as services at master node or None-Worker node!
# Postgres_Version: 11.10
# Script_Version: 0.1

set_env()
{
HOST=192.168.1.198
PORT=5432
USERNAME=postgres
PGPASSWORD="ff20ncd9bc72k3cF"
DATABASENAME=postgres
BACKUPFILENAME=/mnt/hdd/pvc/aiplatform-model-data/
datetime=`date "+%H-%M-%S-%d-%m-%y"`
NIGHTLYBACKUPDIR=$BACKUPFILENAME/$datetime
mkdir -p NIGHTLYBACKUPDIR
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-client-11
}

backup_dbs()
{
dbsets=`echo "SELECT datname FROM pg_database;" | PGPASSWORD=$PGPASSWORD  psql -h $HOST -p $PORT -U $USERNAME | tail -n +3 | head -n -2 | egrep -v 'template0|template1|postgres'`
for idb in ${dbsets[@]} ; do
PGPASSWORD=$PGPASSWORD pg_dump --host $HOST --port $PORT --username $USERNAME -b -c -E UTF-8 --no-owner --no-privileges --no-tablespaces --clean --schema public -F c -Z 9 -f $NIGHTLYBACKUPDIR $idb
done
}


restore_dbs()
{
for file in `ls $path` 
do 
    echo $path"/"$file 
done 

for idb in ${dbsets[@]} ; do
PGPASSWORD=$PGPASSWORD pg_restore --host $HOST --port $PORT --username $USERNAME --dbname $idb --no-owner --no-privileges --no-tablespaces --clean --schema public "$NIGHTLYBACKUPDIR"
done
}


# 向系统添加每晚12:00定时执行任务
set_crontab()
{
apt install -y pg_dump
chmod +w /etc/crontab
echo  "1 * * * * root /bin/sh -C /home/InstallationYTung/sechdule_backup_postgres.sh -host $HOST -port $PORT -user $USERNAME -passwd $PGPASSWORD -t backup " >> /etc/crontab
chmod -w /etc/crontab
service cron restart
}

start_backup_postgres()
{
echo """
# 脚本使用说明：
# Option:
# -host 主机IP
# -port DB的端口
# -user DB的用户名
# -passwd DB的登录密码
# -task 任务：backup 或 restore 或 crontab
# example: ./sechdule_backup_postgres.sh -host 192.168.1.198 -port 5432 -user postgres -passwd ff20ncd9bc72k3cF -t backup
"""

while getopts host:port:user:passwd:task:path: option
do
case "${option}"
in
host) HOST=${OPTARG};;
port) PORT=${OPTARG};;
user) USERNAME=${OPTARG};;
passwd) PGPASSWORD=${OPTARG};;
task) TASK=${OPTARG};;
path) BACKUPFILENAME=${OPTARG};;
esac
done
# 初始化设置环境
set_env  
if [ "backup" == $TASK ];
then  
backup_dbs
fi
if [ "restore" == $TASK ];
then  
restore_dbs 
fi  
if [ "crontab" == $TASK ];
then  
set_crontab
fi 
}

#  Start task
start_backup_postgres