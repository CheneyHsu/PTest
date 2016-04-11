#!/bin/sh

#########################################
#���ip��ַ����������
#������lhl
#date:2012-10-25
#ƽ̨:linux
#########################################
#����޸�2014-02-24  ��������ļ������жϲ�ͬ���
#�����ļ�����:ipmask.conf
#��:ip��ַ   ��������
#172.25.0.55  255.255.0.0

CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
ERRORLOG=${ERRORLOG_PATH}/${CHECKDATE}_mask.log
cat /dev/null >$ERRORLOG

LOGFILE=../file/${HHNAME}_${CHECKDATE}_system.txt
MASKCONF=../conf/ipmask.conf    #�����ļ�

if [ -f ${MASKCONF} ];then
  ifconfig |grep "inet addr" |grep -v 127.0.0.1 |while read i;
  do
    CKIP=`echo ${i} |awk '{print $2}'|awk -F":" '{print $NF}'`
	CKMASK=`echo ${i} |awk -F":" '{print $NF}'`
	grep -qw ${CKIP} ${MASKCONF} 
	if [ $? -eq 0 ];then
	  PZMASK=`grep -w ${CKIP} ${MASKCONF}|awk '{print $NF}'`
	  if [ ${PZMASK} != ${CKMASK} ];then
	    echo "MASK��鱨��:${PZMASK}" ${i}  >>${ERRORLOG}
	  fi	    
	else
	  echo "���������:" ${i}  >>${ERRORLOG}
	fi
  done 
else  
  ifconfig |grep "inet addr" |grep -v 127.0.0.1 |while read i;
  do
    CKIP=`echo $i |awk ' gsub("addr:","",$2) {print $2}'|awk -F"." '{print $1}'`   #���������õ�IP�ĵ�һλ
    CKMASK=`echo ${i} |awk -F":" '{print $NF}'`  #���������õ�IP��Ӧ��MASK
    
    if [ ${CKIP} = "172" ];then
       if [ ${CKMASK} != "255.255.0.0" ];then
         echo "����IP����������:255.255.0.0"   >>${ERRORLOG}  
         echo $i  >>${ERRORLOG}  2>&1		 
       fi
	else
       if [ ${CKMASK} != "255.255.255.0" ];then
         echo "����IP����������:255.255.255.0"   >>${ERRORLOG}  
         echo $i  >>${ERRORLOG}  2>&1		 
       fi
	fi
  done
fi

a=`cat ${ERRORLOG} |wc -l`
if [ $a -eq 0 ];then
  echo "Mask|OK" >>${LOGFILE}
else
  echo "Mask|False" >>${LOGFILE}
fi