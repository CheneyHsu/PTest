#!/bin/sh
# 中国光大银行    
# 只收集灾难恢复优先级

# 开发测试机通用
#编写人员：LHL
# Version v1.1
#2012-10-16
#最后修改2013-08-22


#20130819 判断条件加日志 /file/hoststat.log
#xxxx-yy-dd 格式日期 和检查有没有设置好的主机名
CHECKDATE=`date "+%Y-%m-%d"`



if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

cd  /home/sysadmin/HostInfoCollection/bin

BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_peizhiinfo.txt


cat /dev/null >${LOGFILE}


#判断是什么系统，然后设置语言
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



#灾备恢复优先级  2013-08-19
if [ -f /home/sysadmin/HostInfoCollection/conf/systype.conf ]
then
    SYSTYPEVL=`cat /home/sysadmin/HostInfoCollection/conf/systype.conf`
fi	


echo ${HHNAME}"|"${CHECKDATE}"||||||"$SYSTYPEVL>>${LOGFILE}


