#!/bin/sh

###############################
#  Check zombie 
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

a=`ps -el|awk '$2~/Z/{print}' |wc -l`
if [ $a -gt 5 ]
  then
    echo "28 zombie Check : "
    echo "......................................False" | awk '{printf "%60s\n",$1}'
    echo "Please run (ps -el|awk '\$2~/Z/{print}') check"
    ps -el|awk '$2~/Z/{print}' >${ERRORLOG_PATH}/${CHECKDATE}_zombie.log
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_zombie.log"
  else
    echo "28 zombie Check : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"

