#!/bin/sh
#swap信息收集
#编写人员:lhl
#日期:20121015
LANG=C
LC_ALL=C
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
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_swapinfo.txt

cat /proc/swaps |awk ' !/Filename/ { print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2"|" $3 / 1024 "|" $4 / 1024 }' >${LOGFILE} 
