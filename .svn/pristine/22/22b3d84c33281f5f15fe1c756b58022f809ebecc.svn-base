#!/bin/sh
#20130708
CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi


BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_hbafc.txt
cat /dev/null >${LOGFILE}

if [ -d /sys/class/fc_host ]
then 
   ls /sys/class/fc_host |while read i;
    do
    WWN=`cat /sys/class/fc_host/$i/port_name`
    WWNSTAT=`cat /sys/class/fc_host/$i/port_state`    
    HBASPEED=`cat /sys/class/fc_host/$i/speed`
    echo "${HHNAME}|${CHECKDATE}|${WWN}||${i}|${HBASPEED}|${WWNSTAT}||||" >>${LOGFILE}     
    done
fi




