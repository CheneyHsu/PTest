#!/bin/bash

########################
#  Hardware Status
########################
#2012-07-10修改。日志名改为lsdev_check.log和lspci_check.log
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


LSDEV_TMP=${TMP_PATH}/lsdev.tmp
LSPCI_TMP=${TMP_PATH}/lspci.tmp
LSDEV_SAMPLE=${SAMPLE_PATH}/lsdev.sample
LSPCI_SAMPLE=${SAMPLE_PATH}/lspci.sample
LSDEVLOG=lsdev_check.log
LSPCILOG=lspci_check.log

if [ -f /usr/bin/lsdev ];then
/usr/bin/lsdev >${LSDEV_TMP}
diff ${LSDEV_TMP} ${LSDEV_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "03 lsdev  Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${LSDEV_TMP} ${LSDEV_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_${LSDEVLOG} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LSDEVLOG}"
  else
    echo "03 lsdev Check :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
fi

lspci -vvv -nn -t >${LSPCI_TMP}
diff ${LSPCI_TMP} ${LSPCI_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "03 lspci  Check :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${LSPCI_TMP} ${LSPCI_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_${LSPCILOG} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LSPCILOG}"
  else
    echo "03 lspci Check :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
echo "-------------------------------------------------------------"
