#!/bin/sh
#ftp host8.87.tar.gz to 10.1.32.1
CHECKDATE=`date "+%Y-%m-%d"`
PRLOG=/hostinfo/hostinfo/bin/ftp.log

sh /hostinfo/hostinfo/log/autohostinfo.sh

cd /hostinfo/hostinfo/tmp
tar cvf host8.87.tar *.log |tee -a ${PRLOG} && gzip -f  host8.87.tar  |tee -a ${PRLOG}

ftp -v -n 10.1.32.1 <<EOF  |tee -a ${PRLOG}
user smapp sm030211
prompt
bin
cd /files/system/SM/data
put host8.87.tar.gz
bye  |tee -a  ${PRLOG}
EOF




