#!/bin/bash

#########################
#  Check VCS Status
#########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


CL_SAMPLE=${SAMPLE_PATH}/vcs_status.sample
CL_TMP=${TMP_PATH}/vcs_status.tmp
LOGFILE=vcs_status.log

if [ -d /opt/VRTSvcs/bin ]
then
  ps -ef |grep -q "[h]ashadow"
  if [ $? -eq 0 ]
  then
    /opt/VRTSvcs/bin/hastatus -sum >${CL_TMP}
    diff ${CL_TMP} ${CL_SAMPLE} >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "20 VCS Status :"
      echo "...................................False" | awk '{printf "%60s\n",$1}'
      diff ${CL_TMP} ${CL_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
      echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
    else
      echo "20 VCS Status :"
      echo "......................................OK" | awk '{printf "%60s\n",$1}'
    fi
  else
    echo "20 VCS Status :"
    echo ".....................................NOT_running" | awk '{printf "%60s\n",$1}'
  fi
fi 

echo "-------------------------------------------------------------"
