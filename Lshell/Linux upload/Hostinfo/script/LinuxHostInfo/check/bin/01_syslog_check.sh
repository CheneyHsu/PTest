#!/bin/bash

##########################
#  Check Syslog
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

DATE=`date -d '-1 day'|awk '{printf "%-3s %2s\n",$2,$3}'`
TODAY=`date |awk '{printf "%-3s %2s\n",$2,$3}'`
SYSLOG_CONF=${CONF_PATH}/syslog_check.conf
SYSLOG_TMP=${TMP_PATH}/syslog_check.tmp
LOGFILE=syslog_check.log     #2012-03-29 syslog.log 改为现在

cat ${SYSLOG_CONF} | while read i;
do
  parameter_name=`echo ${i} | awk -F"=" '{print $1}'`
  parameter_value=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
  if [ ${parameter_name} = "SYSLOG" ]
    then
 #     firstline=`grep -n "${DATE}" ${parameter_value} | awk -F":" '{if(NR==1) print $1}'`
 #     syslog_check="cat ${parameter_value}|sed -n \"${firstline},\\\$p\""
      syslog_check="tail -1000 ${parameter_value}| grep -e \"^"${DATE}"\" -e \"^"${TODAY}"\" "
    else
      if [ ${parameter_name} = "EXCEPT" ]
        then
         syslog_check="${syslog_check}""|grep -v \"${parameter_value}\"" 
#         echo "${syslog_check}" > ${SYSLOG_TMP}
         eval "${syslog_check}" >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}

      fi
   fi
done

#echo $syslog_check > ${SYSLOG_TMP}
#sh  ${SYSLOG_TMP} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}

if [ -s ${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} ]
  then
    echo "01 Syslog Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
  else
    echo "01 Syslog  Check :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "--------------------------------------------------------------"
