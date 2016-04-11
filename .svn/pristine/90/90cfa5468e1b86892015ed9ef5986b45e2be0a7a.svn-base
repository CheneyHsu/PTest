#!/bin/sh
# 中国光大银行    
# 判断主备机脚本
# Version v1.1
#抓取全进程 
#20130922
#对root用户加判断

cd  /home/sysadmin/HostInfoCollection/bin

fcstatlog=../tmp/ckrun.log            #检查日志

#收集以前的主备机模式

aa=`ls -lrt /home/sysadmin/HostInfoCollection/file/*hoststatus.log |wc -l`
if [ $aa -eq 0 ]
then
    pdmodel=""
else
    hostusname=`ls -lrt /home/sysadmin/HostInfoCollection/file/*hoststatus.log |tail -1 |awk '{print $NF}'`
    pdmodel=`cat $hostusname |tail -1 |awk -F"|" '{print $17}'`   
fi


#删除以前的日志文件
if [ -f $fcstatlog ]
then 
   rm $fcstatlog
fi

echo "Peizhi Start `date +%Y%m%d_%H%M%S`" >> $fcstatlog


HOSTTYPE=`uname -s`   #"AIX"  "HP-UX"  "Linux"
if [ ${HOSTTYPE} = "AIX" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi

if [ ${HOSTTYPE} = "HP-UX" ]
then
    export LC_ALL=zh_CN.hp15CN
    export LC_ALL=zh_CN.hp15CN
fi

if [ ${HOSTTYPE} = "Linux" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi


for i in `ls ../conf/*CEB.txt`
do 

CHECKCONF=${i}
CHECKOUT=../tmp/checkout.txt
echo ${i}  >> $fcstatlog

cat /dev/null  >${CHECKOUT}

grep -q "^ORACLE" ${CHECKCONF}
if [ $? -eq 0 ]
then
  echo "Oracle检查"   >> $fcstatlog
  ps -ef |grep ora_smon   >> $fcstatlog
  OraPro=`ps -ef |grep ora_smon |grep -v grep |wc -l`
    if [ $OraPro -eq 0 ]
	then
	  echo "ORACLE            未运行" >>${CHECKOUT}
	else
	  echo "ORACLE              运行" >>${CHECKOUT}
	fi
fi



grep -q "^WEB" ${CHECKCONF}
if [ $? -eq 0 ]
then
    processname=`cat ${CHECKCONF} |awk '/^WEB/ {print $3}'`
    processuser=`cat ${CHECKCONF} |awk '/^WEB/ {print $2}'`
	echo "WEB  $processuser  $processname" >>$fcstatlog
	if [ ${HOSTTYPE} = "HP-UX" ]
    then
	    ps -efx  >>$fcstatlog
	    apppro=`ps -efx |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	else
	    COLUMNS=1024
	    ps -ef  >>$fcstatlog
	    if [ ${processuser} != root ];then
	       apppro=`ps -ef |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	    else
	       apppro=`ps -ef |grep -e root -e account |grep ${processname} |grep -v grep |wc -l`
	    fi
	fi
    if [ $apppro -eq 0 ]
	then
	  echo "WEB               未运行" >>${CHECKOUT}	
	else
	  echo "WEB                 运行" >>${CHECKOUT}
	fi
fi

grep -q "^APP" ${CHECKCONF}
if [ $? -eq 0 ]
then
    processname=`cat ${CHECKCONF} |awk '/^APP/ {print $3}'`
    processuser=`cat ${CHECKCONF} |awk '/^APP/ {print $2}'`
	echo "APP $processuser  $processname" >>$fcstatlog 
	if [ ${HOSTTYPE} = "HP-UX" ]
    then	
	ps -efx >>$fcstatlog
	apppro=`ps -efx |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	else
	COLUMNS=1024
	ps -ef   >>$fcstatlog
		if [ ${processuser} != root ];then
	        apppro=`ps -ef |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	    else
	       apppro=`ps -ef |grep -e root -e account |grep ${processname} |grep -v grep |wc -l`
	    fi	
	# apppro=`ps -ef |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	fi
    if [ $apppro -eq 0 ]
	then
	  echo "APP               未运行" >>${CHECKOUT}	
	else
	  echo "APP                 运行" >>${CHECKOUT}
	fi
fi



cat ${CHECKCONF} |grep -q "^IP"
if [ $? -eq 0 ]
then
   echo "IP 检查" >>$fcstatlog  
   cat ${CHECKCONF}|awk '/^IP/ {print $2}' |while read i;
   do
     echo "IP  ${i}" >>$fcstatlog 
     if [ ${HOSTTYPE} = "AIX"  -o ${HOSTTYPE} = "HP-UX" ]
	 then
	    netstat -in >>$fcstatlog   
	 	netstat -in |grep -qw $i
		if [ $? -eq 0 ]
		then
		    echo  "IP  $i     运行">>${CHECKOUT}
		else
		    echo  "IP  $i   未运行">>${CHECKOUT}
        fi
     fi

     if [ ${HOSTTYPE} = "Linux" ]	
	 then
	    ifconfig -a >>$fcstatlog 
     	ifconfig -a |grep -qw $i
		if [ $? -eq 0 ]
		then
		    echo  "IP  $i     运行">>${CHECKOUT}
		else
		    echo  "IP  $i   未运行">>${CHECKOUT}
        fi	
     fi
	done
fi	 
SDATE=`date "+%Y-%m-%d"`  




STNU=`cat ${CHECKOUT}  |wc -l`
ZHU=`cat ${CHECKOUT} |grep " 运行" |wc -l`
BEI=`cat ${CHECKOUT} |grep "未运行" |wc -l`


HOSTMODE=""

if [ $ZHU -eq $STNU ]
then
  HOSTMODE="Primary"
else
    if [ $BEI -eq $STNU ]
    then
       HOSTMODE="Secondary"
    else
       HOSTMODE="Middle"
    fi
fi	

#echo "此服务器状态是:$HOSTMODE"
echo 
#cat ${CHECKOUT} |grep "^IP" |grep " 运行" |awk '{print $2}'

APPNAME=`cat ${CHECKCONF} |awk '/业务名称/ {print $NF}'`
MYHOSTNAME=`hostname`
#FDIP=`echo $( cat ${CHECKOUT} |grep "^IP" |awk '/运行/ {print $2}' )`  
QIP=`cat ${CHECKOUT} |grep "^IP" |grep " 运行" |awk '{print $2}'`
FDIP=`echo $QIP`   
ZBMODEL=`cat ${CHECKCONF} |awk '/灾备模式/ {print $NF}'|sed 's/+/-/'`
APPMODEL=`cat ${CHECKCONF} |awk '/应用角色/ {print $NF}'|sed 's/+/-/g'`
MCDATE=`date "+%Y-%m-%d %H:%M:%S"`
#MYDATE=`date "+%m/%d/%Y %H:%M:%S"`
MYDATE=`date +%s`
HOSTIP=`cat ../conf/HOSTIP.txt`


echo "CEB-HA|+|${APPNAME}|+|1001|+|1001|+|${HOSTIP}|+|${MYHOSTNAME}|+|HAStatus|+|${FDIP:-NA}|+|${HOSTMODE}|+|OS|+|HA|+|${ZBMODEL}|+|5|+|${APPMODEL}|+|${MCDATE}" >>/home/sysadmin/HostInfoCollection/file/$(date "+%Y-%m-%d")_hoststatus.log
logger  -t 2OMNIBUS -p local0.notice "CEB-HA|+|${APPNAME}|+|1001|+|1001|+|${HOSTIP}|+|${MYHOSTNAME}|+|HAStatus|+|${FDIP:-NA}|+|${HOSTMODE}|+|OS|+|HA|+|${ZBMODEL}|+|5|+|${APPMODEL}|+|${MYDATE}"

done 
echo "end `date +%Y%m%d_%H%M%S`"  >>$fcstatlog  

#如果主备机状态有变化保存日志
if [ "${pdmodel}" !=  $HOSTMODE ]
then
    echo "HOSTMODEL|${pdmodel}|$HOSTMODE" >>$fcstatlog   
    cat $fcstatlog  >>../file/hostmodel.txt
fi


#清除30天前文件	
find /home/sysadmin/HostInfoCollection/file -mtime +30 -type f -name *hoststatus.log -exec rm -f {} \;	
