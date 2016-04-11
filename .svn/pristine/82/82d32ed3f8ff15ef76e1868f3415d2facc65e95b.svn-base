#!/bin/bash

###############################
#  Check Kernel Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

CMD=/sbin/lsmod
KMTUNE_SAMPLE=${SAMPLE_PATH}/cfg_kmtune_check.sample
KMTUNE_TMP=${TMP_PATH}/cfg_kmtune_check.tmp
LOGFILE=cfg_kmtune_check.log

$CMD > ${KMTUNE_TMP}
diff ${KMTUNE_TMP} ${KMTUNE_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "08 Kernel Configuration Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${KMTUNE_TMP} ${KMTUNE_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
#    diff ${KMTUNE_TMP} ${KMTUNE_SAMPLE}
  else
    echo "08 Kernel Configuration Check:"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
