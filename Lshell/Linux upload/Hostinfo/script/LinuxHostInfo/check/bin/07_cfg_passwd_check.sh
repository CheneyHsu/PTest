#!/bin/bash

###############################
#  Check /etc/passwd Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

PASSWD_SAMPLE=${SAMPLE_PATH}/cfg_passwd_check.sample
PASSWD_TMP=${TMP_PATH}/cfg_passwd_check.tmp
LOGFILE=cfg_passwd_check.log   #2012-03-29 ÐÞ¸Ä passwd.log

cat /etc/passwd | awk -F':' '{print $1":"$3":"$4":"$5":"$6":"$7}' > ${PASSWD_TMP}
diff ${PASSWD_TMP} ${PASSWD_SAMPLE} >/dev/null 2>&1 
a=$?
if [ $a -ne 0 ]
  then
    echo "07 /etc/passwd Configuration :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${PASSWD_TMP} ${PASSWD_SAMPLE} >${ERRORLOG}/${CHECKDATE}_${LOGFILE} 
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
#    diff ${PASSWD_TMP} ${PASSWD_SAMPLE}
  else
    echo "07 /etc/passwd Configuration :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
