#!/bin/bash

#########################################################################
#
# Cheney Hsu 201308018 v0.4
#
#########################################################################
#import bash module and variable
source /usr/report/Variable.sh
source /usr/report/MVMODULE.sh 

#create reportdiff directory
if [ -d /tmp/report/usr/report ];
then
	:
else
	mkdir -p /tmp/report/usr/report
fi

#disk info
DIFFMV
df -hlP >${TMPDIR_MOUDLE_LINUX}/usr/report/diffdisk1

#inode info
DIFFINODE
df -ilP > ${TMPDIR_MOUDLE_LINUX}/usr/report/diffinode1

#message log 
cp -rf  /var/log/messages  /tmp/report/usr/report/fulllog

#network info
DIFFMVNET
ifconfig | grep  -E '(Link | inet)'  > /tmp/report/usr/report/netdiff1

#route info
route -v >> /tmp/report/usr/report/netdiff1

#user info
DIFFMVUSER
cat /etc/passwd > /tmp/report/usr/report/userdiff1

#memory info
swapon -s > /tmp/report/usr/report/sw

#cluster
clustat > ${TMPDIR_MOUDLE_LINUX}/usr/report/cluster

