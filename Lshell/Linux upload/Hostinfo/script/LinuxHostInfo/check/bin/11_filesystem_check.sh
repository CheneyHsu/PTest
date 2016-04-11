#!/usr/bin/ksh

########################
#  Filesytems Usage
########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
LOG_PATH=../log
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`
LOGFILE=filesystem_check.log
FS_USAGE_CONF=${CONF_PATH}/filesystem_check.conf
FSUSAGE=${TMP_PATH}/filesystem_fsusage.tmp
LV_ERR=/home/sysadmin/check/tmp/lv_err.tmp
echo "0" >${FSUSAGE}

lv_err=0
cat ${FS_USAGE_CONF}|awk -F"=" '{print $1"="}'>${TMP_PATH}/LV_NAME.tmp
echo "0" >${LV_ERR}
df|grep % |awk '/\// {print $NF}' |grep / | while read i;
   do
grep -q "${i}=" ${TMP_PATH}/LV_NAME.tmp
 a=$?
    lv_err=`expr ${lv_err} + ${a}`
   echo ${lv_err} >${LV_ERR}
   done
   b=`cat ${LV_ERR}`
if [ ${b} -eq 0 ]
then
cat /dev/null >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
printf "%-30s%10s%10s\n" Mounted %used %limit >${LOG_PATH}/dflog/${CHECKDATE}_filesystem.log

df|grep % |awk '/\// {print $(NF-1),$NF}' | while read i;
   do
   lv_name=`echo ${i} |awk '{print $2}'`
   lv_value=`echo ${i}|awk '{print $1}'|awk -F"%" '{print $1}'`
   parameter_value=`grep "${lv_name}=" ${FS_USAGE_CONF} |awk -F"=" '{print $2}'`
  if [ ${lv_value} -ge ${parameter_value:-0} ]
    then
      echo "1" >${FSUSAGE}
      echo "The Usage of "${lv_name}" ("${lv_value}"%) has exceeded the limit value: "${parameter_value:-0}"%." >>${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
  fi
   printf "%-30s%10s%10s\n" ${lv_name} ${lv_value}% ${parameter_value:-00}% >>${LOG_PATH}/dflog/${CHECKDATE}_filesystem.log
done
  a=`cat ${FSUSAGE}`
if [ ${a} -eq 0 ]
  then
    echo "11 Filesystems Usage :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
  else
    echo "11 Filesystems Usage :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
fi
else

   printf "%-30s%10s%10s\n" Mounted %used %limit >${LOG_PATH}/dflog/${CHECKDATE}_filesystem.log
df|grep % |awk '/\// {print $(NF-1),$NF}' | while read i;
   do
   lv_name=`echo ${i} |awk '{print $2}'`
   lv_value=`echo ${i}|awk '{print $1}'`
   parameter_value=`grep  "${lv_name}=" ${FS_USAGE_CONF} |awk -F"=" '{print $2}'`
  
   printf "%-30s%10s%10s\n" ${lv_name} ${lv_value} ${parameter_value:-00}% >>${LOG_PATH}/dflog/${CHECKDATE}_filesystem.log
done
    echo "11 Filesystems Usage :"
    echo "...................................error" | awk '{printf "%60s\n",$1}'
fi

echo "filesystem_usage=`pwd|sed 's/check\/bin/check\/log/'`/dflog/${CHECKDATE}_filesystem.log"
echo "----------------------------------------------------------"
