#!/bin/sh
#oracle 失效对像检查。
#检查对像，索引，分区索引等失效。
#2012-08-01
#最后修改 2013-07-16
#加CSB实例判断


CHECKDATE=`date "+%Y-%m-%d"`
rundatemin=`date '+%M'`
DBA_CONF=/home/sysadmin/check/conf/oracle-dba.conf

if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi


DBA_CHECKDIR=/home/sysadmin/check/log/oracledba
#过滤注释，过滤空行

if [ ${ORACLE_SID} = CBS ]
then
#判断是核心时使用monitor/monitor 用户
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

#当非核心CBS实例时使用dbsnmp/dbsnmp
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