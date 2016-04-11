#!/bin/bash

############################################
#  Check Oracle Listener Configuration
############################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

LISTENTER_CONF=${CONF_PATH}/oracle_listener_check.conf
CFG_LISTENER_SAMPLE=${SAMPLE_PATH}/sample
CFG_LISTENER_TMP=${TMP_PATH}/tmp

cat ${LISTENTER_CONF} | while read i;
do
  LISTENTER_NAME=`echo ${i} |sed s'/\//_/g'`
  LISTENTER_FILE_NAME=`echo ${i}`
  cat ${LISTENTER_FILE_NAME} > ${CFG_LISTENER_TMP}${LISTENTER_NAME}

  diff ${CFG_LISTENER_TMP}${LISTENTER_NAME} ${CFG_LISTENER_SAMPLE}${LISTENTER_NAME} >/dev/null 2>&1
  a=$?
  if [ $a -ne 0 ]
    then
      echo "17 ${LISTENTER_NAME} :"
      echo "...................................False" | awk '{printf "%60s\n",$1}'
      diff ${CFG_LISTENER_TMP}${LISTENTER_NAME} ${CFG_LISTENER_SAMPLE}${LISTENTER_NAME} >${ERRORLOG_PATH}/${CHECKDATE}_${LISTENTER_NAME} 2>&1
      echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LISTENTER_NAME}"  
   #   diff ${CFG_LISTENER_TMP}${LISTENTER_NAME} ${CFG_LISTENER_SAMPLE}${LISTENTER_NAME}
    else
      echo "17 ${LISTENTER_NAME} :"
      echo "......................................OK" | awk '{printf "%60s\n",$1}'
  fi
done

echo "----------------------------------------------------------"
