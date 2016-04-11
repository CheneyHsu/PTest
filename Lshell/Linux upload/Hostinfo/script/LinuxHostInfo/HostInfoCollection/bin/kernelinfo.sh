#!/bin/sh
#

CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi


BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
#cat /dev/null >${TMP_PATH}/filesys-info.txt

/sbin/lsmod  |grep -v ^Module |awk '{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2"|lsmod"}'>${FILE_PATH}/${HHNAME}_${CHECKDATE}_kernelinfo.txt
#20140310Ôö¼Ó
/sbin/sysctl -a |sed 's/ = /=/'|awk -F"=" '{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2"|sysctl"}' >>${FILE_PATH}/${HHNAME}_${CHECKDATE}_kernelinfo.txt
