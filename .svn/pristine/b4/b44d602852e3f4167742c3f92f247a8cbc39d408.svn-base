#!/bin/bash

##########################
#  Check PowerPath
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


POWERMT_DISPLAY_SAMPLE=${SAMPLE_PATH}/powermt_display.sample
POWERMT_DISPLAY_TMP=${TMP_PATH}/powermt_display.tmp

if [ -x /sbin/powermt ]
  then
    powermt display dev=all | grep -v "^\---------------- Host ---------------" | grep -v "^### HW Path" | grep -v "^state=" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7}' > ${POWERMT_DISPLAY_TMP}
    diff ${POWERMT_DISPLAY_TMP} ${POWERMT_DISPLAY_SAMPLE} > /dev/null 2>&1
    a=$?
    b=`powermt display dev=all | grep "^state=" | grep -v "^state=alive;" | wc -l`
    if [ $a -ne 0 ]
      then
        echo "21 PowerPath Status :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
         diff ${POWERMT_DISPLAY_TMP} ${POWERMT_DISPLAY_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_powerpath.log
        echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_powerpath.log"
echo
#        powermt display dev=all
      else
        if [ $b -ne 0 ]
          then
            echo "21 PowerPath Status :"
            echo "...................................False" | awk '{printf "%60s\n",$1}'
            echo "Please run \"powermt display dev=all\" check"
#           powermt display dev=all
          else
            echo "21 PowerPath Status :"
            echo "......................................OK" | awk '{printf "%60s\n",$1}'
        fi
     fi
 else
    echo  "21 PowerPath Check :"
    echo "...................................NOT.Check" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
