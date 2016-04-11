#!/bin/bash

##########################
#  Check Volume Group
##########################
#2012-07-10修改日志文件名
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

VG_SAMPLE=${SAMPLE_PATH}/vgdisplay_v.sample
VG_TMP=${TMP_PATH}/vgdisplay_v.tmp
LOGFILE=vgdisplay_vg.log

b=`fdisk -l 2>&1 |grep LVM |wc -l`
 if [ $b -gt 0 ]
    then
vgdisplay -v 2>&1 |grep -v "# open"  > ${VG_TMP}
diff ${VG_TMP} ${VG_SAMPLE} >/dev/null 2>&1
a=$?
if [ $a -ne 0 ]
  then
    echo "10 vgdisplay Status :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    diff ${VG_TMP} ${VG_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} 2>&1
    echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
  else
    echo "10 vgdisplay Status :"
    echo "......................................OK" | awk '{printf "%60s\n",$1}'
fi
   else
    echo "10 vgdisplay Status :"
    echo "....................................NOT_LVM" | awk '{printf "%60s\n",$1}'
fi
echo "----------------------------------------------------------"
