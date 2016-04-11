#!/bin/bash

##########################
#  Initialize Volume Group
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

VG_SAMPLE=${SAMPLE_PATH}/vgdisplay_v.sample
RET=0

b=`fdisk -l 2>&1 |grep LVM |wc -l`
if [ $b -gt 0 ]
   then

vgdisplay -v  2>&1 |grep -v "# open"  > ${VG_SAMPLE} 
a=$?
if [ $a -ne 0 ]
  then
    echo "102 Volume Group Initialization :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    RET=1
  else
    echo "102 Volume Group Initialization :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
    else
    echo "102 Volume Group Initialization :"
    echo "....................................NOT_LVM" | awk '{printf "%60s\n",$1}'
 fi 
echo "----------------------------------------------------------"
echo

exit $RET
