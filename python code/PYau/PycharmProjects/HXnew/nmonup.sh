#!/bin/bash



killall genreport.sh
killall reportdiff.sh
killall getupdate.sh

umask 022
ndate=`date -d yesterday +%y%m%d`
DATE=`date "+%Y%m%d%H"`
FILENAME=`hostname`_`date -d yesterday +%y%m%d`_*.nmon
TMPDIR=/tmp
ftpserver='102.200.2.224'


#for t in  192.168.145.59 172.16.128.179 172.16.66.61 102.200.2.224;do
#ping -c 2 $t
#        if [ $? = 0 ];then
#               ftpserver=$t
#        else
#        . /usr/report/CIP.sh
#        fi
#done
. /usr/report/CIP.sh

# ÎÄ¼þ´«Êä
(
#echo "user report report"
echo "user report2 reportREPORT2"
echo "lcd $TMPDIR" 
echo "asc"
echo "cd  linuxnmon"
echo "prom"
echo "put $FILENAME"
echo "bye"
) | ftp -n -i $ftpserver




if [ $? = 0 ];then
:
else
#SFTP put 
(
echo "lcd $TMPDIR" 
echo "cd  linuxnmon"
echo "put $FILENAME"
echo "bye"
) | sftp root@$ftpserver
fi


/usr/bin/find /tmp -type f -name "*.nmon" -mtime +7 -exec rm -r {} \;


exit 0
