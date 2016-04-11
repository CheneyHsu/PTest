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
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_tapeinfo.txt
#cat /dev/null >${LOGFILE}

cat /etc/hosts |grep -v ^# |grep ^[0-9] |awk '{print $1"|"$2"|"$3}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_hosts.txt
cat /etc/passwd |grep -v ^# |awk -F: '{print $1"|"$3"|"$4"|"$6"|"$7}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_passwd.txt
cat /etc/group |grep -v ^# |awk -F: '{print $1"|"$3"|"$4}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_group.txt
cat /etc/fstab |grep -v ^# |awk '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}'>${FILE_PATH}/${HHNAME}_${CHECKDATE}_fstab.txt

tar cf ${FILE_PATH}/${HHNAME}_${CHECKDATE}_filebak.tar `cat ../conf/filebak.conf |grep -v "^#"`  >/dev/null 2>&1