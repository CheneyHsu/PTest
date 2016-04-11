#!/bin/sh
#网络流量监控，监控流量比较大的一个网卡
#2012-05-15 lhl
#会调用glance 工具和lanadmin,lanscan,netstat 等命令

hpnet() 
{
netinfo=../tmp/net-info.txt
netglance=../tmp/tmp-net.txt

cat /dev/null >${netglance}
mondate=`date +"%Y-%m-%d %H:%M"`
#调用glance工具和 netall 脚本文件
/opt/perf/bin/glance -adviser_only -nosort -iterations 30 -j 2 -syntax ./netall >../tmp/net_glance

#如果要保存各网卡的流量与使用信息把下行注释去掉,会一直追加信息,注意清理文件中内容。
# cat ../tmp/net_glance  >>../tmp/net_glance_all.log


#所有配有Ip地址的网卡
/usr/bin/netstat -in |grep -v : |awk '/lan/ {print $1}' |while read i
  do
     #判断是绑定的网卡还是物理网卡
    if [ ${#i} -lt 6 ]
    then
       lannum=`echo $i |awk -F"lan" '{print $NF}'`
       lanspeed=`/usr/sbin/lanadmin -x  ${lannum} |awk '/Speed/ {print $3}'`
cat ../tmp/net_glance |grep $i |awk '{inbyte+=$3;outbyte+=$4;total+=$5;inpk+=$6;outpk+=$7}END{printf "%s  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.2f\n","'"${mondate}"'",$2,inbyte/NR*1024,outbyte/NR*1024,total/NR*1024,inpk/NR,outpk/NR,"'$lanspeed'",total/NR*8*100/1024/"'$lanspeed'"}' >>$netglance
   else
       lannum=`echo $i |awk -F"lan" '{print $NF}'`
       a=`/usr/sbin/lanscan -q |grep $lannum |awk '{print $NF}'`
       lanspeed=`/usr/sbin/lanadmin -x  ${a} |awk '/Speed/ {print $3}'`

cat ../tmp/net_glance |grep $i |awk '{inbyte+=$3;outbyte+=$4;total+=$5;inpk+=$6;outpk+=$7}END{printf "%s  %s  %.1f  %.1f  %.1f  %.1f  %.1f  %s  %.2f\n","'"${mondate}"'",$2,inbyte/NR*1024,outbyte/NR*1024,total/NR*1024,inpk/NR,outpk/NR,"'$lanspeed'",total/NR*8*100/1024/"'$lanspeed'"}' >>$netglance
   fi
  done
 #每次生成的结果追加到文件${netinfo}中
cat $netglance |sort -nk 6 |tail -1 >>${netinfo}

}

#有glance命令时才执行收集
if [ -f /opt/perf/bin/glance ]
   then 
    hpnet >/dev/null 2>&1 &
fi	
	

