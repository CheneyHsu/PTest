#!/bin/bash

##########################
#  Check Swap
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

SWAP_USAGE_CONF=${CONF_PATH}/swap_usage.conf
if [ -f ${SWAP_USAGE_CONF} ]
   then
     echo "121 ${SWAP_USAGE_CONF}: already exists"
   else
echo "swap=50" >${SWAP_USAGE_CONF}
if [ $? -eq 0 ]
  then
    echo "121 swap_check.conf  :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
  else
    echo "121 swap_check.conf  :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
fi
fi
echo "----------------------------------------------------------"
