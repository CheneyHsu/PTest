#!/bin/sh

###############################
#  检查NTP是束正常
###############################
#通用脚本

BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

LOGFILE=ntp.log
#ntpq -p |grep -q ntpserver
ntpq -p | grep -qe ntpserver -qe 10.1.37.120 -qe 10.1.37.122
a=$?
if [ $a -ne 0 ]
  then
    echo "09 NTPQ Status :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    ntpq -p >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
  else
    ckjg=`ntpq -p |grep "^*" |sed 's/-//g' |awk '{if  ($(NF-1) >= 90000)  {print "False"} else {print "OK"}}'`
    if [ ${ckjg} = OK ];then
       echo "09 NTPQ Status :"
       echo "......................................OK" | awk '{printf "%60s\n",$1}'
	else
       echo "09 NTPQ Status :"
       echo "...................................False" | awk '{printf "%60s\n",$1}'	  
       ntpq -p >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} 2>&1
    fi	   
fi

echo "----------------------------------------------------------"
