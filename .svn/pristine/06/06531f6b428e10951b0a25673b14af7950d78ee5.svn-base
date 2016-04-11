#!/bin/sh
# 中国光大银行    
# 判断主备机脚本
# Version v1.1

#判断oralce是否在进行

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


CHECKCONF=../tmp/checkconf.txt
CHECKOUT=../tmp/checkout.txt
 
 

cat /dev/null  >${CHECKOUT}

grep -q "^ORACLE" ${CHECKCONF}
if [ $? -eq 0 ]
then
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
	if [ ${HOSTTYPE} = "HP-UX" ]
    then
	apppro=`ps -efx |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	else
	COLUMNS=1024
	apppro=`ps -ef |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
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
	if [ ${HOSTTYPE} = "HP-UX" ]
    then	
	apppro=`ps -efx |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
	else
	COLUMNS=1024
	apppro=`ps -ef |grep ${processuser} |grep ${processname} |grep -v grep |wc -l`
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
   cat ${CHECKCONF}|awk '/^IP/ {print $2}' |while read i;
   do
     if [ ${HOSTTYPE} = "AIX"  -o ${HOSTTYPE} = "HP-UX" ]
	 then
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
   
cat ${CHECKOUT}    
STNU=`cat ${CHECKOUT}  |wc -l`
ZHU=`cat ${CHECKOUT} |grep " 运行" |wc -l`
BEI=`cat ${CHECKOUT} |grep "未运行" |wc -l`


HOSTMODE=""

if [ $ZHU -eq $STNU ]
then
  HOSTMODE="主机"
else
    if [ $BEI -eq $STNU ]
    then
       HOSTMODE="备机"
    else
       HOSTMODE="中间"
    fi
fi	

echo "此服务器状态是:$HOSTMODE"
echo 
#cat ${CHECKOUT} |grep "^IP" |grep " 运行" |awk '{print $2}'

APPNAME=`cat ${CHECKCONF} |awk '/业务名称/ {print $NF}'`
MYHOSTNAME=`hostname`
#FDIP=`echo $( cat ${CHECKOUT} |grep "^IP" |awk '/运行/ {print $2}' )`  
QIP=`cat ${CHECKOUT} |grep "^IP" |grep " 运行" |awk '{print $2}'`
FDIP=`echo $QIP`   
ZBMODEL=`cat ${CHECKCONF} |awk '/灾备模式/ {print $NF}'`
APPMODEL=`cat ${CHECKCONF} |awk '/应用角色/ {print $NF}'`
#MYDATE=`date "+%Y-%m-%d %H:%M:%S"`
MYDATE=`date "+%m/%d/%Y %H:%M:%S"`



#echo "CEB-HA|+|${APPNAME}|+|1001|+|1001|+|NA|+|${MYHOSTNAME}|+|HAStatus|+|${FDIP}|+|${HOSTMODE}|+|OS|+|HA|+|${ZBMODEL}|+|5|+|${APPMODEL}|+|${MYDATE}"
#logger  -t 2OMNIBUS "CEB-HA|+|${APPNAME}|+|1001|+|1001|+|NA|+|${MYHOSTNAME}|+|HAStatus|+|${FDIP}|+|${HOSTMODE}|+|OS|+|HA|+|${ZBMODEL}|+|5|+|${APPMODEL}|+|${MYDATE}"

 
	 
