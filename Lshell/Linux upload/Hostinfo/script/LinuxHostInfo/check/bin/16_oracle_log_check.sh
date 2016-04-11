#!/bin/bash

##########################
#  Check Oracle Log
##########################
#×îºóÐÞ¸Ä2013-11-20
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
DATE=`date -d '-1 day'|awk '{printf "%-3s %-3s %2s",$1,$2,$3}'`
CHECKDATE=`date "+%Y-%m-%d"`
ERRORLOG_PATH=../log/errorlog
DATEYEAR=`date +%Y`


ORACLE_LOG_EXCEPT=${CONF_PATH}/oracle_log_except.conf
ORACLE_LOG_CONF=${CONF_PATH}/oracle_log_check.conf
DETAILED=NO

cat ${ORACLE_LOG_CONF} | while read i;
do
  db_name=`echo ${i} | awk -F"=" '{print $1}'`
  logfile=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
  if [ ${db_name} = "DISPLAY_LOG_DETAILS" ]
    then
      DETAILED=${logfile}
    else
      firstline=`grep -n "${DATE} " ${logfile} | grep $DATEYEAR | awk -F":" '{if(NR==1) print $1}'`
      if [ ! -n "${firstline}" ];then
        echo "16 "${db_name}" check:kong"
        echo "......................................OK" | awk '{printf "%60s\n",$1}'
        exit 0
      fi
      cat ${logfile} | sed -n "${firstline},\$p" > ${TMP_PATH}/oracle_log.${db_name}.tmp

   ORACLE_LOG="cat ${TMP_PATH}/oracle_log.${db_name}.tmp|grep \"^ORA\" "
VALUE_ORA=`cat ${ORACLE_LOG_EXCEPT}|grep -v "^#" |wc -l`
if [ ${VALUE_ORA} -gt 0 ]
   then
cat  ${ORACLE_LOG_EXCEPT}|grep -v "^#" | while read i;
 do
   parameter_name=`echo ${i} | awk -F"=" '{print $1}'`
   parameter_value=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
       ORACLE_LOG="${ORACLE_LOG}"" |grep -v  \""${parameter_value}"\""
done
fi
a=`eval "${ORACLE_LOG}"|wc -l`
      if [ $a -eq 0 ]
        then
          echo "16 "${db_name}" check:" 
          echo "......................................OK" | awk '{printf "%60s\n",$1}'
        else
          echo "16 "${db_name}" check:" 
          echo "......................................False" | awk '{printf "%60s\n",$1}'
           eval "${ORACLE_LOG}" >${ERRORLOG_PATH}/${CHECKDATE}_${db_name}_log.log
          echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${db_name}_log.log"         
          echo
      fi
      if [ ${DETAILED} = "YES" ]
        then
          echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
          echo ${logfile}
          echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
          cat ${TMP_PATH}/oracle_log.${db_name}.tmp
          echo
      fi
  fi
done

echo "----------------------------------------------------------"
