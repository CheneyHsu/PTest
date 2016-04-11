#!/bin/bash

#########################
#  Check Bad Login
#########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
SYSLOGFILE=messages.tmp
ERRORLOG=badlogin_check.log
SYSLOG_TMP=${TMP_PATH}/messages.tmp
CHECKDATE=`date "+%Y-%m-%d"`
ERRORLOG_PATH=../log/errorlog

logfile=/var/log/messages
DATEDAY=`date -d '-1 day'|awk '{printf "%-3s %2s\n",$2,$3}'`
TODAY=`date |awk '{printf "%-3s %2s\n",$2,$3}'`
#firstline=`grep -n "${DATEDAY} " ${logfile} | awk -F":" '{if(NR==1) print $1}'`

#cat ${logfile}|sed -n "${firstline},\$p" >${SYSLOG_TMP}
tail -1000 ${logfile} |grep -e "${DATEDAY}" -e "${TODAY}" >${SYSLOG_TMP}
a=`grep "error: PAM:" ${SYSLOG_TMP}|wc -l`

#if [ $a -eq 0 ]
if [ $a -lt 5 ]
  then
    echo "02 Bad Login :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
  else
    echo "02 Bad Login :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
#    echo "Please run (grep \"error: PAM:\" `pwd|sed 's/check\/bin/check\/tmp/'`/$SYSLOGFILE) check."
    grep "error: PAM:" ${SYSLOG_TMP} >${ERRORLOG_PATH}/${CHECKDATE}_${ERRORLOG}
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${ERRORLOG}"


fi
echo "--------------------------------------------------------------"
