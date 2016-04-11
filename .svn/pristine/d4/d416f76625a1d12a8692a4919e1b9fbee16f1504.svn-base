#!/bin/bash

##########################
# crontab 任务检查
##########################
#最后修改2013-01-06 suse redhat crontab文件不在同一目录


BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

if [ -d /var/spool/cron/tabs ];then
  CRONFILE=/var/spool/cron/tabs 
else
  CRONFILE=/var/spool/cron
fi

ls ${CRONFILE}|grep -v total | while read i;

do
  CRON_USER=`echo ${i} |awk '{print $NF}'`
  diff ${CRONFILE}/${CRON_USER} ${SAMPLE_PATH}/${CRON_USER}_cron.sample >/dev/null 2>&1
  if [ $? -eq 0 ]
    then
      echo "24 ${CRON_USER} crontab check :"
      echo "......................................OK" | awk '{printf "%60s\n",$1}'
    else
      echo "24 ${CRON_USER} crontab check :"
      echo "...................................False" | awk '{printf "%60s\n",$1}'
      diff ${CRONFILE}/${CRON_USER} ${SAMPLE_PATH}/${CRON_USER}_cron.sample >${ERRORLOG_PATH}/${CHECKDATE}_${CRON_USER}_cron.log
      echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${CRON_USER}_cron.log"
  fi

done




echo "----------------------------------------------------------"
