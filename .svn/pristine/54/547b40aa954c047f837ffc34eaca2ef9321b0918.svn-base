#!/bin/sh

#########################
# 23 NUB Çý¶¯Æ÷×´Ì¬¼ì²é
#########################
#2012-4-18 Ìí¼Ó
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
LOGFILE=nbudrive.log
CHECKDATE=`date "+%Y-%m-%d"`

if [ -f /usr/openv/volmgr/bin/tpconfig ]
then
   a=`/usr/openv/volmgr/bin/tpconfig -l|grep DOWN |wc -l`
    if [ $a -lt 1 ]
    then
      echo "23 NBU drive check :"
      echo "......................................OK" | awk '{printf "%60s\n",$1}'
    else
       echo "23 NBU drive check :"
       echo "...................................False" | awk '{printf "%60s\n",$1}'
       /usr/openv/volmgr/bin/tpconfig -l|grep DOWN >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE}
       echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
    fi
else
   echo "23 NBU drive check :"
   echo "......................................Not_Media" | awk '{printf "%60s\n",$1}'   
fi	   
	   

echo "--------------------------------------------------------------"