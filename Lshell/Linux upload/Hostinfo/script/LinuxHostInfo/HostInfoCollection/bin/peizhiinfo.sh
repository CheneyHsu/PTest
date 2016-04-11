#!/bin/sh
# �й��������    
# ֻ�ռ����ѻָ����ȼ�

# �������Ի�ͨ��
#��д��Ա��LHL
# Version v1.1
#2012-10-16
#����޸�2013-08-22


#20130819 �ж���������־ /file/hoststat.log
#xxxx-yy-dd ��ʽ���� �ͼ����û�����úõ�������
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


#�ж���ʲôϵͳ��Ȼ����������
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



#�ֱ��ָ����ȼ�  2013-08-19
if [ -f /home/sysadmin/HostInfoCollection/conf/systype.conf ]
then
    SYSTYPEVL=`cat /home/sysadmin/HostInfoCollection/conf/systype.conf`
fi	


echo ${HHNAME}"|"${CHECKDATE}"||||||"$SYSTYPEVL>>${LOGFILE}


