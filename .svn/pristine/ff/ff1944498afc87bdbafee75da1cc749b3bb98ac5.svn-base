#!/bin/bash

###############################
#  Check /etc/group Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

GROUP_SAMPLE=${SAMPLE_PATH}/cfg_group_check.sample
GROUP_TMP=${TMP_PATH}/cfg_group_check.tmp
GROUPLOG=cfg_group_check.log    # 2012-03-29 ÐÞ¸Ägroup.log

cat /etc/group > ${GROUP_TMP}
diff ${GROUP_TMP} ${GROUP_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "05 /etc/group Configuration : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${GROUP_TMP} ${GROUP_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_${GROUPLOG} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${GROUPLOG}"
#    diff ${GROUP_TMP} ${GROUP_SAMPLE}
  else
    echo "05 /etc/group Configuration : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
