#!/bin/bash

############################################
#    Conf Settting
############################################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf


./011_syslog_check_set.sh
./111_filesystem_check_set.sh
./121_swap_check_set.sh


ps -ef |grep -q [o]ra_smon
a=$?
if [ $a = 0 ]
  then 
    ./161_oracle_log_check_set.sh
    ./171_oracle_listener_check_set.sh
    ./181_oracle_lsnrctl_check_set.sh
    ./191_oracle_usage_check_set.sh
  else
    echo  "oracle_log_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "oracle_listener_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "oracle_lsnrctl_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "oracle_usage_.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo

fi

if [ -x /usr/symcli/bin/symrdf ]
  then
    ./221_srdf_check_set.sh
  else
    echo  "221 srdf_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
echo "----------------------------------------------------------"
fi

