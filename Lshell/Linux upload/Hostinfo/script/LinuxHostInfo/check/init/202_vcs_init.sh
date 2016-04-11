#!/bin/bash

#########################
#  Initialize Cluster Status
#########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

CL_SAMPLE=${SAMPLE_PATH}/vcs_status.sample

if [ -d /opt/VRTSvcs/bin ]
then
  ps -ef |grep -q "[h]ashadow"
  if [ $? -eq 0 ]
  then
    /opt/VRTSvcs/bin/hastatus -sum >${CL_SAMPLE}
    if [ $? -ne 0 ]
      then
        echo "202 VCS Status :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
        echo
      else
        echo "202 VCS Status :"
        echo "......................................OK" | awk '{printf "%60s\n",$1}'
    fi
  else
    echo "202 VCS Status :"
    echo "...................................NOT_Running" | awk '{printf "%60s\n",$1}'
fi
fi
echo "-------------------------------------------------------------"
echo
