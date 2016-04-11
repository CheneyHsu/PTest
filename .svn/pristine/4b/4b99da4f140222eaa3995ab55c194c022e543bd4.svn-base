#!/bin/sh
#oracle 失效对像检查。
#检查对像，索引，分区索引等失效。
#2012-08-01
#用户配置名/conf/dba-SID.conf
# 当有dba-SID.conf 配置文件时执行配置文件内容，没有配置文件时执行oracle-dba.conf 中的sql,如果是10G以上的系统执行oracle10-dba.conf配置文件



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
#当用户配置文件不在时
echo "CBS database" >>${ULOG}
cat ${DBA_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn monitor/monitor
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 


#只有10版本以上的oracle才可以查询
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
# 当用户配置文件存在时，执行用户配置文件中的内容。
echo "执行配置文件  $dbauserconf" >>${ULOG} 
cat /home/sysadmin/check/conf/$dbauserconf |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 
    
else
#当用户配置文件不在时
echo "执行配置文件  ${DBA_CONF}"  >>${ULOG}
cat ${DBA_CONF} |grep -v "^#" |grep -v "^$" |awk '{print $1}' |while read i
do
sqlplus -S /nolog >${DBA_CHECKDIR}/${HHNAME}~${ORACLE_SID}~${i}.log <<EOF
conn dbsnmp/dbsnmp
@/home/sysadmin/check/orasql/${i}.sql
exit
EOF
done 


#只有10版本以上的oracle才可以查询
if [ $oraclever -gt 9 ]
then 
echo "执行配置文件  ${DBA10_CONF}"  >>${ULOG}
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
