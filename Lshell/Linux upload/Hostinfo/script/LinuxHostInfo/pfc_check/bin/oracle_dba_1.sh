#!/bin/sh
#oracle ʧЧ�����顣
#����������������������ʧЧ��
#2012-08-01
#����޸� 2013-07-16
#��CSBʵ���ж�


CHECKDATE=`date "+%Y-%m-%d"`
rundatemin=`date '+%M'`
DBA_CONF=/home/sysadmin/check/conf/oracle-dba.conf

if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi


DBA_CHECKDIR=/home/sysadmin/check/log/oracledba
#����ע�ͣ����˿���

if [ ${ORACLE_SID} = CBS ]
then
#�ж��Ǻ���ʱʹ��monitor/monitor �û�
i=get_activeundo
sqlplus -S /nolog >>${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn monitor/monitor
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF

if [ $rundatemin = "00" ]
then

ii=get_res_limit
sqlplus -S /nolog >>${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${ii}.log <<EOF
conn monitor/monitor
@/home/sysadmin/check/orasql/${ii}.sql
exit
EOF
fi
else

#���Ǻ���CBSʵ��ʱʹ��dbsnmp/dbsnmp
i=get_activeundo
sqlplus -S /nolog >>${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF

if [ $rundatemin = "00" ]
then
ii=get_res_limit
sqlplus -S /nolog >>${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${ii}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${ii}.sql
exit
EOF
fi

fi