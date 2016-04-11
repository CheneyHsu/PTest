#!/bin/bash

##########################
#   oracle_lsnrctl_check.conf
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

LSNRCTL_SETTING_TMP=${TMP_PATH}/lsnrctl_setting.tmp
ORACLE_LSNRCTL_CONF=${CONF_PATH}/oracle_lsnrctl_check.conf
FSUSAGE=${TMP_PATH}/oracle_fsusage.tmp
echo 0 >${FSUSAGE}
ps -ef |grep [t]nslsnr |awk ' {print $1,$9}' >${LSNRCTL_SETTING_TMP}
cat /dev/null >${ORACLE_LSNRCTL_CONF}
cat ${LSNRCTL_SETTING_TMP} | while read i;
do
   ORACLE_USERS=`echo ${i} |awk '{print $1}'`
   LSNRCTL_NAME=`echo ${i} |awk '{print $2}'`

   echo "USER="${ORACLE_USERS} >>${ORACLE_LSNRCTL_CONF}
   echo "LISTENER="${LSNRCTL_NAME} >>${ORACLE_LSNRCTL_CONF}
   echo 1 >${FSUSAGE}
done
a=`cat ${FSUSAGE}`

if [ ${a} -eq 0 ]
  then
    echo "181 oracle_lsnrclt_check.conf  :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
  else
    echo "181 oracle_lsnrclt_check.conf  :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
echo "----------------------------------------------------------"
echo

