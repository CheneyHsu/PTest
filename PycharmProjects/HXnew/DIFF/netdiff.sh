#!/bin/bash
#########################################################################
#
# Cheney Hsu 201308018 v0.4
# 网络对比 信息脚本
#########################################################################


#netdf 为临时变量只在本页面显示输出.
A=`grep -vxFf /tmp/report/usr/report/netdiff /tmp/report/usr/report/netdiff1` 
if [ $? = 0 ]
then
	echo "==========================NEW NETWORK============================="
	echo  $A
fi

B=`grep -vxFf /tmp/report/usr/report/netdiff1 /tmp/report/usr/report/netdiff`
if [ $? = 0 ]
then
	echo "==========================OLD NETWORK============================="
	echo  $B
fi
exit 0