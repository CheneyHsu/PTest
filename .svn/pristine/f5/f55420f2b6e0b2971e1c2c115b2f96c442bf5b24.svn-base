#!/bin/bash

#########################################################################
#
# Cheney Hsu 201308018 v0.4
# 账户对比 信息脚本
#########################################################################

#ADD和DEL为临时变量,只在本页有效
ADD=`grep -vxFf /tmp/report/usr/report/userdiff /tmp/report/usr/report/userdiff1`
if [ $? = 0 ]
then
	echo "=======================新增加用户============================="
	echo "${ADD}"
fi

DEL=`grep -vxFf /tmp/report/usr/report/userdiff1 /tmp/report/usr/report/userdiff`
if [ $? = 0 ]
then
	echo "=======================删除用户==============================="
	echo "${DEL}"
fi
