#!/bin/bash
export LANG=c

##########################
#create log 
##########################
#removedate=`date +%d`
#curdate=`date +%H`
logdir=/home/sar/log
logcpuuse=$logdir/cpuuse.log
logcpuload=$logdir/cpuload.log
logioload=$logdir/ioload.log
lognetworkload=$logdir/networkload.log
logsysprocess=$logdir/sysprocess.log
logmemuse=$logdir/memuse.log
lognetsession=$logdir/netsession.log
mkdir -p $logdir
##############################
#       cpu use
##############################
if [ -f $logcpuuse ]
then
#echo "logfile is exist !"
date +"%D %r" >>$logcpuuse
sar -u 1 1 |grep all |head -2 >> $logcpuuse
else
#touch $logfile

date > $logcpuuse
sar -u 1 1 | grep CPU >> $logcpuuse

fi

################################
#       cpu load
################################
if [ -f $logcpuload ]
then
#echo "logfile is exist !"

uptime  >> $logcpuload
else
#touch $logfile
date > $logcpuload
uptime >> $logcpuload
fi

################################
#       disk I/O
################################
if [ -f $logioload ]
then
date +"%D %r" >> $logioload
iostat -xd 1 1 | sed -n '2,$p' >> $logioload

else
date +"%D %r" > $logioload
iostat -xd 1 1 | sed -n '2,$p' >> $logioload
fi

################################
#       network
################################
if [ -f $lognetworkload ]
then
date +"%D %r" >> $lognetworkload
sar -n DEV 1 1| grep eth1 >> $lognetworkload

else
date +"%D %r" > $lognetworkload
sar -n DEV 1 1|head -3 |tail -1 >> $lognetworkload
sar -n DEV 1 1| grep eth1 >> $lognetworkload
fi

# note: please use ethtool . set eth0 or eth1

################################
#       memory
################################
if [ -f $logmemuse ]
then
date +"%D %r" >> $logmemuse
free |grep -1 Mem |head -n 2|tail -1 >> $logmemuse
free | grep Swap >> $logmemuse
else
date +"%D %r" > $logmemuse
free |grep -1 Mem |head -n 2 >> $logmemuse
free | grep Swap >> $logmemuse
fi


################################
#   network  TCP
################################
if [ -f $lognetsession ]
then
date +"%D %r" >> $lognetsession
netstat -an | grep -E "^(tcp)" | cut -c 74- | sort | uniq -c | sort -n >> $lognetsession
else
date +"%D %r" >> $lognetsession
netstat -an | grep -E "^(tcp)" | cut -c 74- | sort | uniq -c | sort -n >> $lognetsession
fi

exit 0

