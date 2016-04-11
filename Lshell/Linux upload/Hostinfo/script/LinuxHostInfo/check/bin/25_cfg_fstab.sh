#!/bin/sh

###############################
#  Check /etc/fstab Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


LOGFILE=cfg_fstab_check.log
FSTAB_SAMPLE=${SAMPLE_PATH}/cfg_fstab_check.sample
FSTAB_TMP=${TMP_PATH}/cfg_fstab_check.tmp

cat /etc/fstab > ${FSTAB_TMP}
diff ${FSTAB_TMP} ${FSTAB_SAMPLE} > /dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "25 /etc/fstab Configuration :"  
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${FSTAB_TMP} ${FSTAB_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
  else
    echo "25 /etc/fstab Configuration : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"

