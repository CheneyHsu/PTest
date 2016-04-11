#!/bin/sh
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
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_scsiinfo.txt
#cat /dev/null >${LOGFILE}

lspci |grep SCSI |awk '{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' >${LOGFILE}
