#!/bin/sh
##############################
#  oracle DBA 的日常检查项
##############################
#最后修改 20130827
#HP-UNIX,AIX,Linux 通用


BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
SET_PATH=../set
ERRORLOG_PATH=../log/errorlog
TBS_PATH=../log/tbslog
#CHECKDATE=`date "+%Y-%m-%d"`

#检查失效对像 
#ps -ef |grep [o]ra_smon |while read i;
ps -ef |grep ora_smon |grep -v grep |while read i;
do
  ORACLE_USERS=`echo ${i}|awk '{print $1}'`
  DB_NAME=`echo ${i} |awk -F"smon_" '{print $NF}'`
#  echo "${DB_NAME}  " `date` >>${checklog}
  su - "${ORACLE_USERS}"  <<! >/dev/null 2>&1
    export ORACLE_SID="${DB_NAME}"
    cd /home/sysadmin/pfc_check/bin
    sh oracle_dba_1.sh

!

done

#echo "----------------------------------------------------------"


