#!/bin/bash
a=`date +%Y%m%d`
b=`date +%Y%m%d%M`
echo $a
tail -n 4 /root/rsync.log |grep timeout

if [ $? = 0 ];
then
	ps -aux | grep rsync| grep -v rsyncup.sh|grep -v rsyncscan.sh | grep -v grep
	if [ $? = 1 ]
	then
		mv /root/rsync.log  /root/rsynclog/rsync.log.$b
		cp /root/list/list2.$a /root/list/list2
		kill -9 `ps -aux | grep rsyncup | grep -v -E 'Warning|grep' |awk '{print $2}'`
		bash /root/rsyncup.sh
		echo 1 >> /root/number
	else
		mv /root/rsync.log /root/rsynclog/rsync.log.$b
		cp /root/list/list2.$a /root/list/list2
		kill -9 `ps -aux | grep rsyncup | grep -v -E 'Warning|grep' |awk '{print $2}'`
		bash /root/rsyncup.sh
		echo 2 >> /root/number
	fi
else
	:
fi
