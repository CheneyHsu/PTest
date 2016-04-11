#!/bin/bash

#########################################################################
#
# Cheney Hsu 201308018 v0.4
# 内存对比部分
#########################################################################


#内存赋值,这个变量只在本页面生效.
Free=`cat /tmp/report/usr/report/sw | grep / |awk '{print $3}'`
Used=`cat /tmp/report/usr/report/sw | grep / |awk '{print $4}'`

#SWAP分区的使用
#echo "====================SWAP====================================="
#echo -e ""Size: ${Free}"  "Used: ${Used}""

#swap使用百分比
#echo "====================SWAP使用百分比============================="
U=`echo "scale=2;${Used}/${Free}*100"|bc|awk -F "." '{print $1}'`

#如果大于50%就显示出来
if [ "${U}" -gt 49 ]
then
  echo "====================SWAP使用百分比============================="
	echo "${U}"
#else
#	echo "============================================================"
#	echo "${U} "
fi
#echo "=====================实际物理内存和cache=========================="
#echo '实际物理内存的百分比'
#ps -eo rss | awk '
#BEGIN { printf "物理内存: " }
#/^ *[0-9]/ { total_rss += $1 }
#END { printf total_rss " KiB\n" }'
#echo "cache:`grep ^Cache /proc/meminfo`"
#echo "buffer: `grep Buffer /proc/meminfo`"

exit 0
