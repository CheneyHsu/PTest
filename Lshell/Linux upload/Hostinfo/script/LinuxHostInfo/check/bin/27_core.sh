#!/bin/sh

###############################
#  Check core Configuration
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log

a=`ls /var/adm/crash |wc -l`
if [ $a -ne 0 ]
  then
    echo "27 core Check : "
    echo "......................................False" | awk '{printf "%60s\n",$1}'
    echo "Please Chechk \"/var/adm/crash\" "
  else
    echo "27 core Check : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"

