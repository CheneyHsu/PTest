#!/bin/bash

##########################
#  Check Oracle Listener
##########################
BIN_PATH=../bin
SAMPLE_PATH=/home/sysadmin/check/sample
TMP_PATH=/home/sysadmin/check/tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

ORACLE_LSNRCTL_CONF=${CONF_PATH}/oracle_lsnrctl_check.conf
ORACLE_LSNRCTL_SAMPLE=${SAMPLE_PATH}/oracle_lsnrctl_status.sample
ORACLE_LSNRCTL_TMP=${TMP_PATH}/oracle_lsnrctl_status.tmp
WORKDIR=`pwd`

cat ${ORACLE_LSNRCTL_CONF} | while read i;
do
  parameter_name=`echo ${i} | awk -F"=" '{print $1}'`
  parameter_value=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
  if [ ${parameter_name} = "USER" ]
    then
      LSNRCTL_USER=${parameter_value}
    else
      if [ ${parameter_name} = "LISTENER" ]
        then
           su - ${LSNRCTL_USER} <<!  >/dev/null 2>&1
          lsnrctl status ${parameter_value} | grep -v "^LSNRCTL" | grep -v "^Start Date" | grep -v "^Uptime" > /tmp/${LSNRCTL_USER}.${parameter_value}.tmp
#          su - $LSNRCTL_USER -c "lsnrctl status ${parameter_value} | grep -v \"^LSNRCTL\" | grep -v \"^Start Date\" | grep -v \"^Uptime\"" > ${ORACLE_LSNRCTL_TMP}.${LSNRCTL_USER}
!

 diff /tmp/${LSNRCTL_USER}.${parameter_value}.tmp /tmp/${LSNRCTL_USER}.${parameter_value}.sample > /dev/null 2>&1

          a=$?
          if [ $a -ne 0 ]
            then
              echo "18 "${LSNRCTL_USER}.${parameter_value}" Status :"
              echo "...................................False" | awk '{printf "%60s\n",$1}'
 diff /tmp/${LSNRCTL_USER}.${parameter_value}.tmp /tmp/${LSNRCTL_USER}.${parameter_value}.sample > ${ERRORLOG_PATH}/${CHECKDATE}_${LSNRCTL_USER}.${parameter_value}.log
              
echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LSNRCTL_USER}.${parameter_value}.log"
            else
              echo "18 "${LSNRCTL_USER}.${parameter_value}" Status :"
              echo "......................................OK" | awk '{printf "%60s\n",$1}'
          fi
      fi
  fi
done

echo "----------------------------------------------------------"
