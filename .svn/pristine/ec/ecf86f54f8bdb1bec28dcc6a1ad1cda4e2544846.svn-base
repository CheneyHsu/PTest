#!/bin/bash

##########################
#  Check Swap
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
SWAP_PATH=../log/swaplog
CHECKDATE=`date "+%Y-%m-%d"`

SWAP_USAGE_CONF=${CONF_PATH}/swap_usage.conf
USAGE=`free |grep Swap |awk '{printf "%.0f\n",$3/$2*100}'`
PARAMETER_VALUE=`cat ${SWAP_USAGE_CONF}|awk -F"=" '{print $2}'`
LOGFILE=swap_check.log

#echo ${CHECKDATE} "mm-dd-yyyy" >>${ERRORLOG_PATH}/swap.log
echo /dev/null >${SWAP_PATH}/${CHECKDATE}_swap.log
printf "%18s%11s%11s%11s%11s\n"  total used free %used %limit >>${SWAP_PATH}/${CHECKDATE}_swap.log
printf "%40s%11s%11s\n" "`free|grep Swap`" "${USAGE}%" "${PARAMETER_VALUE}%">>${SWAP_PATH}/${CHECKDATE}_swap.log


if [ ${USAGE} -ge ${PARAMETER_VALUE} ]
 then
   echo "The Usage of Swap ("${USAGE}"%) has exceeded the limit value: "${PARAMETER_VALUE}"%." >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
   echo "12 Swap Usage :"
   echo "......................................False" | awk '{printf "%60s\n",$1}'
   echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
 else
    echo "12 Swap Usage :"
    echo "...................................OK" | awk '{printf "%60s\n",$1}'
fi
   echo "swap_log=`pwd|sed 's/check\/bin/check\/log/'`/swaplog/${CHECKDATE}_swap.log"
echo "----------------------------------------------------------"
