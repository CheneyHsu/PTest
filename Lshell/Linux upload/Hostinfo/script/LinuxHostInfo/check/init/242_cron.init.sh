#!/bin/bash

############################################
# Cron Initialize 
############################################
#最后修改2013-01-06 suse redhat crontab文件目录不同
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
if [ -d /var/spool/cron/tabs ];then
  CRONFILE=/var/spool/cron/tabs 
else
  CRONFILE=/var/spool/cron
fi


ls  ${CRONFILE}|grep -v total | while read i;
  
do
  CRON_USER=`echo ${i} |awk '{print $NF}'`
  cat ${CRONFILE}/${CRON_USER} >${SAMPLE_PATH}/${CRON_USER}_cron.sample
  echo "242 ${CRON_USER}  Cron Initialize :"
  echo "...................................OK" | awk '{printf "%60s\n",$1}'

done


echo "----------------------------------------------------------"
echo

exit
