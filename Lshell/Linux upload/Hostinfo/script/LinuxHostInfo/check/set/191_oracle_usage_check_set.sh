#!/bin/bash


##########################
#   Oracle Usage Setting
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
SET_PATH=../set
CHECKDATE=`date "+%Y-%m-%d"`

ORACLE_USAGE_CONF=${CONF_PATH}/oracle_usage_

cp ${SET_PATH}/oracle_usage.sql /tmp/oracle_usage.sql

ps -ef |grep [o]ra_smon |while read i;
do
  ORACLE_USERS=`echo ${i}|awk '{print $1}'`
  DB_NAME=`echo ${i} |awk -F"ora_smon_" '{print $NF}'`
  if [ -f ${ORACLE_USAGE_CONF}${DB_NAME}.conf ]
    then 
su - "${ORACLE_USERS}" <<! >/dev/null 2>&1
   export ORACLE_SID="${DB_NAME}"
   sqlplus /nolog
   connect /as sysdba
   spool on
   spool /tmp/${DB_NAME}.tmp
   @/tmp/oracle_usage.sql
   spool off
!
       cp ${ORACLE_USAGE_CONF}${DB_NAME}.conf  ${ORACLE_USAGE_CONF}${DB_NAME}.conf_${CHECKDATE}
       cat /dev/null >${ORACLE_USAGE_CONF}${DB_NAME}.conf
       cat /tmp/${DB_NAME}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep -v '^$' |awk '{print $1}'| while read i;
         do
           grep -wq ${i} ${ORACLE_USAGE_CONF}${DB_NAME}.conf_${CHECKDATE}
           if [ $? = 0 ]
             then 
               FS_US=`grep -w ${i} ${ORACLE_USAGE_CONF}${DB_NAME}.conf_${CHECKDATE} |awk -F"=" '{print $2}'`
               echo ${i}"=${FS_US}" >>${ORACLE_USAGE_CONF}${DB_NAME}.conf
             else
              echo ${i}"=90" >>${ORACLE_USAGE_CONF}${DB_NAME}.conf
           fi
         done
		  if [ -s ${ORACLE_USAGE_CONF}${DB_NAME}.conf ]
            then
              echo "191 ${ORACLE_USAGE_CONF}${DB_NAME}.conf:"
              echo "......................................OK" | awk '{printf "%60s\n",$1}'
            else
              echo "191 ${ORACLE_USAGE_CONF}${DB_NAME}.conf:"
              echo "...................................False" | awk '{printf "%60s\n",$1}'
          fi

  else
  su - "${ORACLE_USERS}" <<! >/dev/null 2>&1
   export ORACLE_SID="${DB_NAME}"
   sqlplus /nolog
   connect /as sysdba
   spool on
   spool /tmp/${DB_NAME}.tmp
   @/tmp/oracle_usage.sql
   spool off
!
     cat /dev/null >${ORACLE_USAGE_CONF}${DB_NAME}.conf
     cat /tmp/${DB_NAME}.tmp |grep -v ^"SQL>"|grep -v "rows selected"|grep -v '^$' |awk '{print $1}'| while read i;
      do
        echo ${i}"=90" >>${ORACLE_USAGE_CONF}${DB_NAME}.conf
      done
     if [ -f ${ORACLE_USAGE_CONF}${DB_NAME}.conf ]
       then
         echo "191 ${ORACLE_USAGE_CONF}${DB_NAME}.conf  setting:"
         echo "......................................OK" | awk '{printf "%60s\n",$1}'
       else
         echo "191 ${ORACLE_USAGE_CONF}${DB_NAME}.conf  setting:"
         echo "...................................False" | awk '{printf "%60s\n",$1}'
     fi
  

fi
done
echo "----------------------------------------------------------"







