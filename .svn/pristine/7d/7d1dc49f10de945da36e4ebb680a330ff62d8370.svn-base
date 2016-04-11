#!/bin/sh
#查询vcs信息
#20130606
#通用  
#最近修改20131210

cd /home/sysadmin/HostInfoCollection/bin

CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi


BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file

#集群信息

HASYSNAME=`cat /etc/VRTSvcs/conf/sysname`   #本地节点名
LCSYS=`/opt/VRTS/bin/hasys -state -localclus |grep -v "#System"|wc -l`    #本地节点数 超过一就是多节点。
HACLUSINFO=`/opt/VRTS/bin/haclus -display -localclus |egrep  -e ClusState -e ClusterAddress  -e ClusterName |awk '{printf "%s|",$2}'`  #本地集群信息
echo "${HHNAME}|${CHECKDATE}|${HACLUSINFO}${HASYSNAME}|${LCSYS}" >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-haclusif.txt


#资源组信息  Frozen为1代表永久冻结  TFrozen为1代表临时冻结
/opt/VRTS/bin/hagrp -state -localclus |grep ${HASYSNAME} |awk '/State/{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$3$4}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-hagrp.txt
/opt/VRTS/bin/hagrp -display -localclus |grep -i froze |awk '{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2"|"$3"|"$4}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-hagrp-froze.txt
#资原信息
/opt/VRTS/bin/hares -state |grep ${HASYSNAME} |awk '/State/ {print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$3"|"$4}'   >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-hares.txt
#集群IP
#/opt/VRTS/bin/haclus -display |awk '/ClusterAddress/ {print "'"${HHNAME}|${CHECKDATE}"'|"$2}' >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-haclus-ip.txt

if [ -f /etc/llttab ]
then
cat /etc/llttab >${FILE_PATH}/vcs_llttab.txt
cat /dev/null >${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-lltstat.txt
/opt/VRTS/bin/lltstat -nvv |grep -v "^LLT" |grep -e  OPEN -e ":" |while read i;
do
    a=`echo "$i" |grep OPEN |wc -l`
    if [ $a -gt 0 ]
    then
      vcs_host=`echo "$i" |awk '{print $(NF-1)}'`
	  continue
     fi

    b=`echo "$i" |grep -e lan -e eth |wc -l`
    if [ $b -gt 0 ]
    then
        vcs_lan=`echo "$i"`
    echo "$vcs_lan"  |awk '{print "'"${HHNAME}|${CHECKDATE}|$vcs_host"'|"$1"|"$2"|"$3}' >>${FILE_PATH}/${HHNAME}_${CHECKDATE}_vcs-lltstat.txt
    fi
done
fi





