#!/bin/bash

############################################
#   Oracle Listener Conf Settting
############################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf


ORACLE_LISTENER_CONF=${CONF_PATH}/oracle_listener_check.conf
ORACLETEST=${TMP_PATH}/oracletest.tmp
echo 0 >${ORACLETEST}

cat /dev/null >${ORACLE_LISTENER_CONF}
ps -ef |grep [t]nslsnr |awk '{print $1,$9}' | while read i;
do
   ORACLE_USERS=`echo ${i} |awk '{print $1}'`
   LSNRCTL_NAME=`echo ${i} |awk '{print $2}'`
   su - ${ORACLE_USERS} -c "lsnrctl status ${LSNRCTL_NAME}" 2>&1|grep "Listener Parameter File"|awk '{print $NF}' >>${ORACLE_LISTENER_CONF}

echo $? >${ORACLETEST}

done

a=`cat ${ORACLETEST}`
if [ $a -eq 0 ]
 then
   echo "171 Oracle Listener Configuration Setting :"
   echo "......................................OK" | awk '{printf "%60s\n",$1}'
 else
   echo "171 Oracle Listener Configuration Setting :"
   echo "...................................False" | awk '{printf "%60s\n",$1}'
   echo
fi
echo "----------------------------------------------------------"
echo

