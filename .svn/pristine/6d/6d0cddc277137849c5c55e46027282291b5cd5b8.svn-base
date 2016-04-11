#!/bin/bash

##########################
#  Check PowerPath
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

POWERMT_DISPLAY_SAMPLE=${SAMPLE_PATH}/powermt_display.sample
RET=0

powermt display dev=all | grep -v "^\---------------- Host ---------------" | grep -v "^### HW Path" | grep -v "^state=" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7}' > ${POWERMT_DISPLAY_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "212 PowerPath Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "212 PowerPath Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
