#!/bin/bash


##########################
#  Check Oracle Usage
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
SET_PATH=../set
ERRORLOG_PATH=../log/errorlog
TBS_PATH=../log/tbslog
CHECKDATE=`date "+%Y-%m-%d"`

LOGFILE=oracle_usage_check.log
ORACLE_USAGE_CONF=${CONF_PATH}/oracle_usage_


cp ${SET_PATH}/oracle_usage.sql /tmp/oracle_usage.sql
cat /dev/null >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
cat /dev/null >${TBS_PATH}/${CHECKDATE}_oracle_usage.log
chmod 775 /tmp/oracle_usage.sql
chmod 777 /home/sysadmin/check/log/oracledba
#检查失效对像 
checklog=/home/sysadmin/check/log/errorlog/${CHECKDATE}_oracle_result.log
checkstatus=/home/sysadmin/check/tmp/19_1status.log
cat /dev/null >${checkstatus}
cat /dev/null >${checklog}
chmod -R 777 ${checklog}
chmod -R 777 ${checkstatus}

#ps -ef |grep [o]ra_smon |while read i;
ps -ef |grep ora_smon |grep -v grep |while read i;
do
  ORACLE_USERS=`echo ${i}|awk '{print $1}'`
  DB_NAME=`echo ${i} |awk -F"smon_" '{print $NF}'`
#  ORACLE_DIRECTORY=`ps -ef |grep [t]nslsnr | grep -w "${ORACLE_USERS}" |awk '{print $8}'|awk -F/bin/ '{print $1}'`    #2012-09-14 linux 的改为print $8
  echo "${DB_NAME}  " `date` >>${checklog}
  su - "${ORACLE_USERS}"  <<! >/dev/null 2>&1
  oraclever=``
#    if [ ! -n "${ORACLE_HOME}" ]
 #     then
 #     export ORACLE_HOME=${ORACLE_DIRECTORY}
 #   fi     
    export ORACLE_SID="${DB_NAME}"
    cd /home/sysadmin/check/bin
    sh 19_1oracle_object.sh
    sh 38_oracle_dba_1.sh	
    sqlplus /nolog
    connect /as sysdba
    spool on
    spool /tmp/${DB_NAME}.tmp
    @/tmp/oracle_usage.sql
    spool off
    exit;
!
#set oracle tablespace  usage
   
   printf "%-15s%-30s%10s%10s\n" db_name tablespace  %used %limit >>${TBS_PATH}/${CHECKDATE}_oracle_usage.log
   cat ${ORACLE_USAGE_CONF}${DB_NAME}.conf |while read i;
     do
       parameter_name=`echo ${i} | awk -F"=" '{print $1}'`
       parameter_value=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
       CURRENT_VALUE=`grep -w "${parameter_name}" /tmp/${DB_NAME}.tmp |awk '{printf "%.0f\n",$4}'`

#Save tablespace usage 
      printf "%-15s%-30s%10s%10s\n" "${DB_NAME}" "${parameter_name}" "${CURRENT_VALUE}" "${parameter_value}">>${TBS_PATH}/${CHECKDATE}_oracle_usage.log
     

      if [ "${CURRENT_VALUE}" -ge "${parameter_value}" ]
         then
           echo "The ${DB_NAME} Usage of "${parameter_name}" ("${CURRENT_VALUE}"%) has exceeded the limit value: "${parameter_value}"%." >>${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
       fi
     done
done


if [  ! -s ${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} ]
  then
    echo "19 Oracle Usage Check :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
    echo "tablespace_usage=`pwd|sed 's/check\/bin/check\/log/'`/tbslog/${CHECKDATE}_oracle_usage.log" 
  else
    echo "19 Oracle Usage Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
    echo "tablespace_usage=`pwd|sed 's/check\/bin/check\/log/'`/tbslog/${CHECKDATE}_oracle_usage.log" 
fi

orastatus=`cat ${checkstatus} |awk '{sum+=$1} END {print sum}'`
if [ ${orastatus} -eq 0 ]
  then
    echo "19_1 Oracle Objects Check :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
  else
    echo "19_1 Oracle Objects Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_oracle_result.log"
fi


echo "----------------------------------------------------------"


