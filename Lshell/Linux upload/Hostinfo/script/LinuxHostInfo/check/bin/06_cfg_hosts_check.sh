#!/bin/bash

###############################
#  Check /etc/hosts Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

HOSTS_SAMPLE=${SAMPLE_PATH}/cfg_hosts_check.sample
HOSTS_TMP=${TMP_PATH}/cfg_hosts_check.tmp
LOGFILE=cfg_hosts_check.log              #2012-03-29 ÐÞ¸Ä   hosts.log

cat /etc/hosts > ${HOSTS_TMP}
diff ${HOSTS_TMP} ${HOSTS_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "06 /etc/hosts Configuration :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${HOSTS_TMP} ${HOSTS_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
#    diff ${HOSTS_TMP} ${HOSTS_SAMPLE}
  else
    echo "06 /etc/hosts Configuration :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
