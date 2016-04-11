#!/bin/sh
#oracle 失效对像检查。
#检查对像，索引，分区索引等失效。
#2012-08-01
CHECKDATE=`date "+%Y-%m-%d"`
checklog=/home/sysadmin/check/log/errorlog/${CHECKDATE}_oracle_result.log

sqlplus -S /nolog >/dev/null <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
col coun new_value v_coun
select count(*) coun from dba_objects where status='INVALID';
exit v_coun
EOF
OBJECTS="$?"
echo "The number of INVALID object is $OBJECTS."  >>${checklog}
sqlplus -S /nolog >/dev/null <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
col coun new_value v_coun
select count(*) coun from dba_indexes where status='UNUSED';
exit v_coun
EOF
INDEXES="$?"
echo "The number of UNUSED INDEX is $INDEXES." >>${checklog}
sqlplus -S /nolog >/dev/null <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
col coun new_value v_coun
select count(*) coun from dba_ind_partitions where status='UNUSED';
exit v_coun
EOF
PA_INDEXES="$?"
echo "The number of UNUSED partition index is $PA_INDEXES." >>${checklog}
if [ $OBJECTS != 0 ]
then
sqlplus -S /nolog >>${checklog} <<EOF
--set feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
set lines 130
col owner format a15
col object_type format a20
col object_name format a35
select owner,object_type,object_name from dba_objects where status='INVALID';
exit
EOF
fi
if [ $INDEXES != 0 ]
then
sqlplus -S /nolog >>${checklog} <<EOF
--set feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
set lines 130
col TABLE_OWNER format a15
col index_name format a35
select TABLE_OWNER,index_name coun from dba_indexes where status='UNUSED';
exit
EOF
fi
if [ $PA_INDEXES != 0 ]
then
sqlplus -S /nolog >>${checklog} <<EOF
--set feedback off pagesize 0 verify off echo off numwidth 4
conn dbsnmp/dbsnmp
set lines 130
col index_name format a35
select index_name,partition_name coun from dba_ind_partitions where status='UNUSED';
exit
EOF
fi
orastatus=$(($OBJECTS+$INDEXES+$PA_INDEXES))
echo ${orastatus}>>/home/sysadmin/check/tmp/19_1status.log
