#!/bin/sh
#View Memory Use Status
echo ""
vmstat -s -S M
echo ""
PS=`ls /proc/*[0-9]*|grep :` ;
PSList=`echo $PS | tr -d '/proc' | tr -d ':' | sort `;
echo -e "#PID\t\t#MEMSize\t\t#MEMUse\t\t\t#Name\t\t#CMD"
for PID in $PSList
do
test -e /proc/$PID/status && \
sPID=`cat /proc/$PID/status | grep ^Pid:` && \
sMEMsize=`cat /proc/$PID/status | grep ^VmSize: | awk '{print $1,$2/1024,"M"}'` && \
sMEMuse=`cat /proc/$PID/status | grep ^VmRSS: | awk '{print $1,$2/1024,"M"}'` && \
sName=`cat /proc/$PID/status | grep ^Name:` && \
if [ -e /proc/$PID/exe ]
then
 sCMD=`ls -alF /proc/$PID/exe | awk '{print }' | tr -d '$*' | awk '{print $11}'`
fi
echo -e "$sPID\t$sMEMsize\t$sMEMuse\t$sName\tCMD:\t$sCMD" | egrep 'VmSize|VmRSS' >> /tmp/mem001
done
cat /tmp/mem001 | sort -n -r -t " " -k 2 | head -10
rm -rf /tmp/mem001
