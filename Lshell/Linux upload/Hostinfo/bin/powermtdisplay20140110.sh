#!/bin/sh
cd /hostinfo/hostinfo/data

ls  *powermtdisplay.txt |while read s
do

fchostname=`echo $s |awk -F"_" '{print $1}'`
fcdate=`echo $s |awk -F"_" '{print $(NF-1)}'`

cat $s |grep -ve "=="|grep -ve "###"|grep -ve "----" |while read i
do

o=`echo "$i" |grep "Pseudo name" |wc -l`
if [ $o -gt 0 ]
then
   psedudoname=`echo "$i" |awk -F"=" '{print $NF}'`
fi

o=`echo "$i" |grep "Symmetrix ID" |wc -l`
if [ $o -gt 0 ]
then
   hisymmid=`echo "$i" |awk -F"=" '{print $NF}'`
fi

o=`echo "$i" |grep "Logical device ID" |wc -l`
if [ $o -gt 0 ]
then
   ldid=`echo "$i" |awk -F"=" '{print $NF}'`
fi

o=`echo "$i" |grep "^state=" |wc -l`
if [ $o -gt 0 ]
then
  hfstate=`echo "$i" |awk 'BEGIN{RS="^state="}gsub(/^state=/,"")gsub(/;/,""){print $1}'`
fi

o=`echo "$i" |grep "policy=" |wc -l 2>&1`
if [ $o -gt 0 ]
then
  hfpolicy=`echo "$i" |awk -F"policy=" '{print $2}'|awk -F";" '{print $1}'`
fi

o=`echo "$i" |grep "priority=" |wc -l`
if [ $o -gt 0 ]
then
  hfpriority=`echo "$i" |awk -F"priority=" '{print $2}'|awk -F";" '{print $1}'`
fi

o=`echo "$i" |grep "queued-IOs=" |wc -l`
if [ $o -gt 0 ]
then
  hfqueued=`echo "$i" |awk -F'queued-IOs=' '{print $2}'|awk -F";" '{print $1}'`
fi

o=`echo "$i" |grep -e active -e alive |wc -l`
if [ $o -gt 0 ]
then
  hfdisk=`echo "$i"|awk 'BEGIN{OFS="|"}{print $1,$2,$3,$4,$5,$6,$7,$8,$9}'`
fi

k=`echo "$i" |grep "^$" |wc -l`

if [ $k -gt 0 ]
then
   echo "$fchostname|$fcdate|$psedudoname|$hisymmid|$ldid|$hfstate|$hfpolicy|$hfpriority|$hfqueued|$hfdisk" >>../datatmp/powermtdisplay.log
psedudoname=""
hisymmid=""
ldid=""
hfstate=""
hfpolicy=""
hfpriority=""
hfqueued=""
hfdisk=""
fi

done

done
