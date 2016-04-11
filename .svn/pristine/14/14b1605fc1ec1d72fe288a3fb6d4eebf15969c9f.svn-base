#!/bin/bash

###############################
#  Initialize /etc/passwd Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

PASSWD_SAMPLE=${SAMPLE_PATH}/cfg_passwd_check.sample
RET=0

cat /etc/passwd | awk -F':' '{print $1":"$3":"$4":"$5":"$6":"$7}' > ${PASSWD_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "072 /etc/passwd Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "072 /etc/passwd Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
