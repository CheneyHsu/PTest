#!/bin/bash

###############################
#  syslog_log_except.conf SETTING
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf


ORACLE_EXCEPT=${CONF_PATH}/oracle_log_except.conf
if [ -f ${ORACLE_EXCEPT} ]
   then
     echo "161 ${ORACLE_EXCEPT} : already exists"
   else
echo "#EXCEPT=ORA-20000:" >${CONF_PATH}/oracle_log_except.conf
a=$?
   if [ $a -eq 0 ]
     then
       echo "161 oracle_log_except.conf:"
       echo "......................................OK" | awk '{printf "%60s\n",$1}'
      else
        echo "161 oracle_log_except.conf:"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
    fi
fi

echo "----------------------------------------------------------"
echo
  
