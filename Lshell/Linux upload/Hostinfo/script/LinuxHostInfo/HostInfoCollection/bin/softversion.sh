#!/bin/sh
#查看软件的版本信息
#目前都有check,pfc_check,hostinfo
#编写人员:lhl
#DATE: 20121017

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
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_softversion.txt
cat /dev/null >${LOGFILE}
#check scripts
if [ -f /home/sysadmin/check/bin/Upload.sh ]
then 
    a=`cat /home/sysadmin/check/bin/Upload.sh |grep [Vv]ersion |grep -v ^#|sed 's/echo //'`
    echo $HHNAME"|"$CHECKDATE"|"check"|"$a >>${LOGFILE} 
fi	

if [ -f /home/sysadmin/pfc_check/bin/pfc_check.sh ]
then
    b=`cat /home/sysadmin/pfc_check/bin/pfc_check.sh |grep [Vv]ersion |grep -v ^#|sed 's/echo //'`
    echo $HHNAME"|"$CHECKDATE"|"pfc_check"|"$b >>${LOGFILE} 
fi	
c=`cat HostInfoCollect.sh |grep 'Version V'|grep -v "^#"|sed 's/echo //'`
echo $HHNAME"|"$CHECKDATE"|"hostinfo"|"$c >>${LOGFILE} 

