#!/bin/sh
# �鿴�ļ�ϵͳ��Ϣ
#ƽ̨��suse-linux
#����޸�:20140210


LANG=C
LC_ALL=C
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
cat /dev/null >${TMP_PATH}/filesys-info.txt
#df -Pk |grep -v ^Filesystem |awk '{gsub (/%/,"",$(NF-1));print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2"|"$4"|"$5"||||"$6}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_filesysteminfo.txt
df -PkT |grep -v ^Filesystem |awk '{gsub (/%/,"",$(NF-1));print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$3"|"$5"|"$6"||||"$7"|"$2}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_filesysteminfo.txt


