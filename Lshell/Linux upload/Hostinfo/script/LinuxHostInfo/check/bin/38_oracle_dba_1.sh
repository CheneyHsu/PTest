#!/bin/sh
#oracle ʧЧ�����顣
#����������������������ʧЧ��
#2012-08-01
#�û�������/conf/dba-SID.conf
# ����dba-SID.conf �����ļ�ʱִ�������ļ����ݣ�û�������ļ�ʱִ��oracle-dba.conf �е�sql,�����10G���ϵ�ϵͳִ��oracle10-dba.conf�����ļ�



CHECKDATE=`date "+%Y-%m-%d"`
DBA_CONF=/home/sysadmin/check/conf/oracle-dba.conf
DBA10_CONF=/home/sysadmin/check/conf/oracle10-dba.conf
ULOG=/home/sysadmin/check/log/${CHECKDATE}_log.log

if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi

DBA_CHECKDIR=/home/sysadmin/check/log/oracledba


oraclever=`sqlplus -v |grep [0-9] |awk '{print $3}'|awk -F"." '{print $1}'`
dbauserconf="dba-${ORACLE_SID}.conf"

if [ ${ORACLE_SID} = CBS ]
then
#���û������ļ�����ʱ
echo "CBS database" >>${ULOG}
cat ${DBA_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn monitor/monitor
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 


#ֻ��10�汾���ϵ�oracle�ſ��Բ�ѯ
if [ $oraclever -gt 9 ]
then 
cat ${DBA10_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn monitor/monitor
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 
fi

else


if [ `ls /home/sysadmin/check/conf* |grep -w $dbauserconf|wc -l` -gt 0 ]
then 
# ���û������ļ�����ʱ��ִ���û������ļ��е����ݡ�
echo "ִ�������ļ�  $dbauserconf" >>${ULOG} 
cat /home/sysadmin/check/conf/$dbauserconf |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 
    
else
#���û������ļ�����ʱ
echo "ִ�������ļ�  ${DBA_CONF}"  >>${ULOG}
cat ${DBA_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 


#ֻ��10�汾���ϵ�oracle�ſ��Բ�ѯ
if [ $oraclever -gt 9 ]
then 
echo "ִ�������ļ�  ${DBA10_CONF}"  >>${ULOG}
cat ${DBA10_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 
fi

fi
fi
