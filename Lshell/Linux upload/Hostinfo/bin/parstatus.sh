#!/bin/sh

#����hp ��npar ,vpar,vm��Ϣ
#AIX ��Lpar��Ϣ
#hpvmstatus.txt  parstatus.txt vparstatus.txt lparstat.txt

cd /smdb/hostinfo/data

if [ ! -n "$CHECKDATE" ]
then
    CHECKDATE=`date "+%Y-%m-%d"`
fi


#HP NPAR����
for i in `ls *${CHECKDATE}_parstatus.txt`
do
    # ����vpar����ı�����Ϣ
    a=`grep -i error $i |wc -l`
	if [ $a -ne 0 ]
	then
	  continue
	fi    

    HNAME=`echo $i |awk -F"_" '{print $1}'`
    PZA=`awk -F":" '/Partition Number|Partition Name/ {gsub("^ ","",$2);printf "%s|",$2}' $i`
    echo "$HNAME|${CHECKDATE}|$PZA" >>/smdb/hostinfo/datatmp/parstatus.log
done

#HP Vpar����
for i in `ls *${CHECKDATE}_vparstatus.txt`
do 
    # ����vpar����ı�����Ϣ
    a=`grep -i error $i |wc -l`
	if [ $a -ne 0 ]
	then
	  continue
	fi
	
    HNAME=`echo $i |awk -F"_" '{print $1}'`
    PZV=`awk -F: ' !/Warning/ {print $1"|"$2}' $i`
    echo "$HNAME|${CHECKDATE}|$PZV" >>/smdb/hostinfo/datatmp/vparstatus.log
done


#HP VM ����
for i in `ls *${CHECKDATE}_hpvmstatus.txt`
do
    HNAME=`echo $i |awk -F"_" '{print $1}'`
    awk '{if (NR>3) print "'$HNAME'|'${CHECKDATE}'|"$1"|"$2"|"$3}' $i  >>/smdb/hostinfo/datatmp/hpvmstatus.log
done


#AIX Lpar ��Ϣ
for i in `ls *${CHECKDATE}_lparstat.txt`
do
    HNAME=`echo $i |awk -F"_" '{print $1}'`
    PZA=`awk -F":" '{if (NR<6) {gsub("^ ","",$2);printf "%s|",$2}}' $i` 
	echo "$HNAME|${CHECKDATE}|$PZA" >>/smdb/hostinfo/datatmp/lparstat.log
done






