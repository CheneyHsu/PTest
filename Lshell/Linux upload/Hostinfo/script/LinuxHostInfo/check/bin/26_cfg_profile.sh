#!/bin/sh

###############################
#  Check /etc/profile Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


LOGFILE=cfg_profile_check.log
PROFILE_SAMPLE=${SAMPLE_PATH}/cfg_profile_check.sample
PROFILE_TMP=${TMP_PATH}/cfg_profile_check.tmp

cat /etc/profile > ${PROFILE_TMP}
diff ${PROFILE_TMP} ${PROFILE_SAMPLE} > /dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "26 /etc/profile Configuration :"  
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${PROFILE_TMP} ${PROFILE_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
  else
    echo "26 /etc/profile Configuration : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"

