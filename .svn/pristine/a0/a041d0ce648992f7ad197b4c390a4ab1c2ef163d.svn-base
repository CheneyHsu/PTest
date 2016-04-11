#!/bin/sh

###############################
#判断批量自动化程序是否在运行
#开发：lhl
#date:2012-10-25


BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

LOGFILE=../file/${HHNAME}_${CHECKDATE}_system.txt


if [ -d /home/entegor ] 
then
    a=`ps -ef |grep -v grep|grep entegor |wc -l` 
    if [ $a -gt 0 ]
    then
        echo "Agent|OK" >>${LOGFILE}
      else
        echo "Agent|False" >>${LOGFILE}
    fi
fi



