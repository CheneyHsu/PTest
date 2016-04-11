#!/bin/bash

##########################
#  Initialize Network
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

NETSTAT_IN_SAMPLE=${SAMPLE_PATH}/netstat_in.sample
NETSTAT_RVN_SAMPLE=${SAMPLE_PATH}/netstat_rvn.sample
BONDING_SAMPLE=${SAMPLE_PATH}/lanscan.sample
RET=0

ifconfig -a|grep -v RX |grep -v TX > ${NETSTAT_IN_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "132 IFCONFIG -A Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "132 IFCONFIG -A Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

netstat -rn > ${NETSTAT_RVN_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "132 NETSTAT -RN Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=`expr $RET + 1`
  else
    echo "132 NETSTAT -RN Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi


if [ -f /proc/net/bonding/bond0 ]
  then
    cat /proc/net/bonding/bond0 |grep -v "Link Failure Count:" >${BONDING_SAMPLE}    
    a=$?
      if [ $a -eq 0 ]
        then
          echo "132 Bonding Initialization :"
          echo "......................................OK" | awk '{printf "%60s\n",$1}'
        else
          echo "132 Bonding Initialization :"
          echo "...................................False" | awk '{printf "%60s\n",$1}'
          echo
          RET=`expr $RET + 1`
       fi
  else
      echo "132 Bonding Configuration Check :"
      echo "...................................False" | awk '{printf "%60s\n",$1}'
      echo
      RET=`expr $RET + 1` 

fi


echo "----------------------------------------------------------"
echo

exit $RET
