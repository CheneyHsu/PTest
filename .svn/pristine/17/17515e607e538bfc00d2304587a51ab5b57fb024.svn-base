#!/bin/sh
#收集oracle信息
#2012-05-18  oracle版本信息，用户信息，表空间信息
#最后修改2012-10-19

CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

FILE_PATH=../file
TMP_PATH=../tmp
oracle_ver=${FILE_PATH}/${HHNAME}_${CHECKDATE}_oraclever.txt
oracle_tbs=${FILE_PATH}/${HHNAME}_${CHECKDATE}_oracletbs.txt
oracle_user=${FILE_PATH}/${HHNAME}_${CHECKDATE}_oracleuser.txt
oracle_parameter=${FILE_PATH}/${HHNAME}_${CHECKDATE}_oracleparameter.txt
#cp  oracle_info_usage.sql /tmp
#cp  dba_users.sql /tmp
#chmod 775 /tmp/oracle_info_usage.sql
cat /dev/null >${oracle_ver}
cat /dev/null >${oracle_tbs}
cat /dev/null >${oracle_user}
cat /dev/null >${oracle_parameter}
ps -ef|grep [o]ra_smon|awk 'sub(/ora_smon_/,"",$NF){print $1,$NF}' | while read i;
 do
   USERNAME=`echo ${i}|awk '{print $1}'`
   DBSID=`echo ${i}|awk '{print $2}'`
   su - "${USERNAME}" <<EOO >/dev/null 2>&1
      export ORACLE_SID=${DBSID}
    sqlplus '/as sysdba'
   set pagesize 0
   col tablespace_name format a30
   spool on
   spool /tmp/oracle_version.tmp
   select * from v\$version;
   spool /tmp/info_${DBSID}.tmp
   @/home/sysadmin/HostInfoCollection/bin/oracle_info_usage.sql;
   spool /tmp/user_${DBSID}.tmp
   @/home/sysadmin/HostInfoCollection/bin/dba_users.sql; 
   spool /tmp/parameter_${DBSID}.tmp
   @/home/sysadmin/HostInfoCollection/bin/parameter.sql;
   spool off
EOO
   DBVER=`grep CORE /tmp/oracle_version.tmp|awk '{print $2}'`
#oracle Port
  cat /dev/null >${TMP_PATH}/oracle_port.tmp
  
 #取数据库监听名。  linux 下项中是$9; aix,hp是$10
    ps -ef |grep [t]nslsnr |awk ' {print $1,$(NF-1)}' |while read k;
        do
          LSNRCTL_USER=`echo ${k}|awk '{print $1}'`
          parameter_value=`echo ${k}|awk '{print $2}'`
          su - $LSNRCTL_USER -c "lsnrctl status ${parameter_value}" >${TMP_PATH}/LSNRCTL.tmp 2>&1
          cat ${TMP_PATH}/LSNRCTL.tmp |grep Instance |grep -wq ${DBSID} 
           if [ $? -eq 0 ]
             then
        cat ${TMP_PATH}/LSNRCTL.tmp |grep "HOST=" |head -1 |awk -F"=" '{print $NF}'|awk -F")" '{print $1}'>>${TMP_PATH}/oracle_port.tmp
           fi
   
         done
 
   ORACLE_PORT=`cat ${TMP_PATH}/oracle_port.tmp`
   echo $HHNAME"|"${CHECKDATE}"|"${USERNAME}"|"${DBSID}"|"${DBVER}"|"${ORACLE_PORT} >>${oracle_ver} 
   cat /tmp/user_${DBSID}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep [A-Z]|sed 's/ //g'|awk '{print "'"${HHNAME}|${CHECKDATE}|${DBSID}"'|"$0}'>>${oracle_user}
 #  cat /tmp/user_${DBSID}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep [A-Z]|awk ' {print "18 USER;""'${DBSID}'  " $0}'>>${TMP_PATH}/oracle_user.tmp
  # cat /tmp/info_${DBSID}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep -v '^$'|awk '{print "'"${HHNAME}|${CHECKDATE}|${DBSID}"'|"$1"|"$2}'>>${oracle_tbs}
   cat /tmp/info_${DBSID}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep [A-Z,a-z]|sed 's/ //g'|awk '{print "'"${HHNAME}|${CHECKDATE}|${DBSID}"'|"$0}'>>${oracle_tbs}
   cat /tmp/parameter_${DBSID}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep [A-Z,a-z]|sed 's/ //g'|awk '{print "'"${HHNAME}|${CHECKDATE}|${DBSID}"'|"$0}'>>${oracle_parameter}
 done
#cat ${oracle_ver}
#cat ${oracle_tbs}
#cat ${oracle_user}

