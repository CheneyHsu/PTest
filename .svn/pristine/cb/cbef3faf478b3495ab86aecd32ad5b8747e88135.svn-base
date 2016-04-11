#!/bin/bash

########################
#  Hardware Initialization
########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

LSDEV_SAMPLE=${SAMPLE_PATH}/lsdev.sample
LSPCI_SAMPLE=${SAMPLE_PATH}/lspci.sample
RET=0

if [ -f /usr/bin/lsdev ];then
/usr/bin/lsdev >${LSDEV_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "032 lsdev Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "032 lsdev Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
fi

echo "----------------------------------------------------------"
echo

lspci -vvv -nn -t > ${LSPCI_SAMPLE}
a=$?
if [ $a -ne 0 ]
  then
    echo "032 lspci Initialization : "
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    RET=1
  else
    echo "032 lspci Initialization : "
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo

exit $RET
