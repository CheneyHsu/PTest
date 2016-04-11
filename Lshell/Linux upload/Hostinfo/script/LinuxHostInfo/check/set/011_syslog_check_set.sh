#!/bin/bash

###############################
#  syslog_check.conf SETTING
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf



SYSLOG_CONF=${CONF_PATH}/syslog_check.conf
if [ -f ${SYSLOG_CONF} ]
   then
     echo "011 ${SYSLOG_CONF} : already exists"
   else
SYSNAME=`uname -n`

echo "SYSLOG=/var/log/messages" >${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "syslog-ng" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "su" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "sshd" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=Accepted keyboard-interactive/pam" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "error: PAM" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=Setting tty modes failed:" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "/usr/sbin/cron" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT="$SYSNAME "crontab" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=zmd: NetworkManagerModule (WARN)" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=zmd: Daemon (WARN)" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=zmd: ShutdownManager" >>${CONF_PATH}/syslog_check.conf
echo "EXCEPT=2OMNIBUS" >>${CONF_PATH}/syslog_check.conf
a=$?
   if [ $a -eq 0 ]
     then
       echo "010 syslog_check.conf :"
       echo "......................................OK" | awk '{printf "%60s\n",$1}'
      else
        echo "010 syslog_check.conf :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
    fi
fi
echo "----------------------------------------------------------"
echo
  
