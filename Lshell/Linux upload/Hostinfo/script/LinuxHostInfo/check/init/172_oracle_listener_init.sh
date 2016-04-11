#!/bin/bash

############################################
#  Initialize Oracle Listener Configuration
############################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf


LISTENTER_CONF=${CONF_PATH}/oracle_listener_check.conf
CFG_LISTENER_SAMPLE=${SAMPLE_PATH}/sample
RET=0

cat ${LISTENTER_CONF} | while read i;
  do
    LISTENTER_TMP_NAME=`echo ${i} |sed s'/\//_/g'`
    LISTENTER_FILE_NAME=`echo ${i}`
    cat ${LISTENTER_FILE_NAME}> ${CFG_LISTENER_SAMPLE}${LISTENTER_TMP_NAME}
    a=$?
  done;
if [[ "$a" -ne 0 ]]
  then
    echo "172 Oracle Listener Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "172 Oracle Listener Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
