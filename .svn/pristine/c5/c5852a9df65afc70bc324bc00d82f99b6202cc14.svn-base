#!/bin/bash

##########################
#  Check Network
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

NETSTAT_IN_SAMPLE=${SAMPLE_PATH}/netstat_in.sample
NETSTAT_IN_TMP=${TMP_PATH}/netstat_in.tmp
NETSTAT_RVN_SAMPLE=${SAMPLE_PATH}/netstat_rvn.sample
NETSTAT_RVN_TMP=${TMP_PATH}/netstat_rvn.tmp
BONDING_SAMPLE=${SAMPLE_PATH}/lanscan.sample
BONDING_TMP=${TMP_PATH}/lanscan.tmp

ifconfig -a|grep -v RX |grep -v TX > ${NETSTAT_IN_TMP}
diff ${NETSTAT_IN_TMP} ${NETSTAT_IN_SAMPLE} >/dev/null 2>&1 
a=$?
if [ $a -ne 0 ]
  then
    echo "13_1 IFCONFIG -A Status :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${NETSTAT_IN_TMP} ${NETSTAT_IN_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_netstat_in.log 
    echo "Please run \"ifconfig -a \" check."
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_netstat_in.log}"

 #   ifconfig -a 
    echo
  else
    echo "13_1 IFCONFIT -A Status :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

netstat -rn > ${NETSTAT_RVN_TMP}
diff ${NETSTAT_RVN_TMP} ${NETSTAT_RVN_SAMPLE} >/dev/null 2>&1 
a=$?
if [ $a -ne 0 ]
  then
    echo "13_2 NETSTAT -RN Status :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${NETSTAT_RVN_TMP} ${NETSTAT_RVN_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_netstat_rvn.log 
    echo "Please run \"netstat -rn\" check."
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_netstat_rvn.log"

#    netstat -rn
    echo
  else
    echo "13_2 NETSTAT -RN Status :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

if [ -f /proc/net/bonding/bond0 ]
  then
    cat /proc/net/bonding/bond0 |grep -v "Link Failure Count:" >${BONDING_TMP}
    diff ${BONDING_TMP} ${BONDING_SAMPLE} >/dev/null 2>&1
    a=$?
    if [ $a -ne 0 ]
      then
        echo "13_3 bonding Status :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
        diff ${BONDING_TMP} ${BONDING_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_lanscan.log
  #     echo "logfile=/proc/net/bonding/bond0"
        echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_lanscan.log"
 #       cat /proc/net/bonding/bond0
        echo
      else
        echo "13_3 bonding Status :"
        echo "......................................OK" | awk '{printf "%60s\n",$1}'
     fi
#   else
#     echo "13_3 bonding Check:"
#     echo "...................................False" | awk '{printf "%60s\n",$1}'
#     echo
fi

echo "----------------------------------------------------------"
