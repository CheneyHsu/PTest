#!/bin/bash
#光大银行系统日常检查系统
echo "Version v2.0 2014-06-15"
#增加oracle-dba检查
#主机重名增加配置文件
#2012-01-06 修改24 crontab检查脚本
#加了35判断ip子网掩码是不是255.255.255.0
#增加36判断自动备份进程有没有启动
#2012-09-29 改变了日志保留时间命令
#v1.7中统一了和版本中的日志名称(03,10,16,17,18,22)
#v1.7中crontab 计划任务加入上root用户中。

#version:v1.6 
#2012--04-18添加23_nbu_check 检查NBU Media Server 的Drive 状态
#2012-03-22 解决16 oracle日志检查中的一个bug，查询出往年的信息。

#如果有服务在运行，就不再启动新的服务
a=`ps -ef |grep "check/bin/Upload.sh" |grep "sh -c" |grep -v grep |wc -l`
if [ $a -gt 1 ]
then
   echo "running"
   exit;
fi



if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi

export LANG=C
export LC_ALL=C
export HHNAME


RAVEDIRECTORY=../file
UPDIRECTORY="/smdb/check/log"
UPERRORLOG=${UPDIRECTORY}/errorlog
LOGFILE=/home/sysadmin/check/file
ERRORLOG=/home/sysadmin/check/log/errorlog
UPUSER="smdb"
UPPASSWD="smdbput"
UPIP="10.200.8.87"
CHECKDATE=`date "+%Y-%m-%d"`


cd /home/sysadmin/check/bin
sh dailycheck.sh >$RAVEDIRECTORY/${HHNAME}_${CHECKDATE}.txt 2>&1
if [ $? -eq 0 ]
  then
    echo "Check  OK"
  else
    echo "Check  False"
fi

#20140618 加oracle日志清理
test -f /home/sysadmin/dba/clear_log/clear_log.sh &&  /home/sysadmin/dba/clear_log/clear_log.sh >>/home/sysadmin/check/file/check_out.txt  & 




#find /home/sysadmin/check/log/dflog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/errorlog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/swaplog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/tbslog -mtime +92 -type f -name *.log -exec rm -f {} \;
find /home/sysadmin/check/log -mtime +92 -type f -exec rm -f {} \;
find /home/sysadmin/check/file -mtime +92 -type f -name "*.txt" -exec rm -f {} \;
find /home/sysadmin/check/log/errorlog -type f -size 0 -exec rm -f {} \;


cd ${ERRORLOG}
ls |grep "^${CHECKDATE}" |while read i;
do
  mv ${i} ${HHNAME}_${i}
done

#oracle DBA 
cd /home/sysadmin/check/log/oracledba

if [ -f /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar ]
then
   rm -f /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar
fi

tar cf /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar  *.log && rm -f  /home/sysadmin/check/log/oracledba/*.log


cd ${LOGFILE}
ftp  -v -n $UPIP <<EOF
user  $UPUSER $UPPASSWD
prompt off
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}*.txt

cd ${UPDIRECTORY}/errorlog
lcd ${ERRORLOG}
mput ${HHNAME}_${CHECKDATE}*

cd ${UPDIRECTORY}/oracledba
lcd /home/sysadmin/check/log/oracledba
mput *oracledba.tar

bye
EOF
exit;
