#!/bin/sh
#linux  crontab 任务收集


CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi


BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file

if [ -d /var/spool/cron/tabs ];then
  cronmu=/var/spool/cron/tabs 
else
  cronmu=/var/spool/cron
fi


cd ${cronmu}
ls | while read i
do
   cp ${i}   /home/sysadmin/HostInfoCollection/file/${i}_cron.txt
done


