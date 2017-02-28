#!/bin/bash
. /etc/profile
reporttar=`find /usr/report -mtime -1 -name report.tar|wc -l`
if [ "`ps -ef|grep -v grep|grep genreport.py`" == "" ] && [ $reporttar -eq 1 ] && [ "`ps -ef|grep -v grep|grep reportdiff.py`" == "" ];then
		cd /usr/report
		tar -xf report.tar -C /
		if [ $? -eq 0 ];then
			rm -r /usr/report/report.tar
		else
			mv report.tar report.tar.$DATE
		fi
fi
/usr/bin/find /tmp/report -type f -name "$HXSERVERID.*.html" -mtime +7 -exec rm -r {} \; 
chmod -R 755 /usr/report/*
