#!/bin/bash

################################
#   oracle_log_check.conf Set
#################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

LOG_SETTING_TMP=${TMP_PATH}/oracle_log_conf_setting.tmp
ORACLE_LOG_CONF=${CONF_PATH}/oracle_log_check.conf
if [ -f ${ORACLE_LOG_CONF} ]
   then 
     echo "161 ${ORACLE_LOG_CONF} : already exists"
   else

find /oracle  -type f -name "alert_*.log"|grep bdump >${LOG_SETTING_TMP}
echo "DISPLAY_LOG_DETAILS=NO" >${ORACLE_LOG_CONF}

cat ${LOG_SETTING_TMP} | while read i;
do
  ORACLE_USERS=`echo ${i} |awk -F"alert_" '{print $2}'|awk -F"." '{print $1}'`
  LOG_NAME=`echo ${i}`

   echo ${ORACLE_USERS}"="${LOG_NAME} >>${ORACLE_LOG_CONF}
   a=$?
done

if [[ "$a" -ne 0 ]]
  then
    echo "161 oracle_log_check.conf  :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
  else
    echo "161 oracle_log_check.conf  :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
fi
echo "----------------------------------------------------------"
echo

exit 
