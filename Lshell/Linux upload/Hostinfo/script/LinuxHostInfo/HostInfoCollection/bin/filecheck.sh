#!/bin/sh
TMP_PATH=../tmp
BAK_PATH=../bak
CONF_PATH=../conf
FILE_PATH=../file
SAMPLE_PATH=../sample
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`
HHNAME=`uname -n`


#CMD=/sbin/lsmod


if [ -f ${SAMPLE_PATH}/passwd ]
  then
    cp /etc/passwd ${TMP_PATH}/
    cp /etc/fstab ${TMP_PATH}/
    cp /etc/hosts ${TMP_PATH}/
#    $CMD > ${TMP_PATH}/kmtune
   
    diff ${TMP_PATH}/passwd ${SAMPLE_PATH}/passwd  >/dev/null 2>&1
    if [ $? -eq 0 ]
      then
        BACKUPSTATUS="${BACKUPSTATUS} passwd_check_OK"
      else
        cp ${TMP_PATH}/passwd ${SAMPLE_PATH}/passwd
        cp ${TMP_PATH}/passwd ${FILE_PATH}/${HHNAME}_${CHECKDATE}_passwd
        BACKUPSTATUS="${BACKUPSTATUS} passwd_check_False"
    fi
   
    diff ${TMP_PATH}/fstab ${SAMPLE_PATH}/fstab  >/dev/null 2>&1
    if [ $? -eq 0 ]
      then
        BACKUPSTATUS="${BACKUPSTATUS} fstab_check_OK"
      else
        cp ${TMP_PATH}/fstab ${SAMPLE_PATH}/fstab
        cp ${TMP_PATH}/fstab ${FILE_PATH}/${HHNAME}_${CHECKDATE}_fstab
         BACKUPSTATUS="${BACKUPSTATUS} fstab_check_False"
    fi
    diff ${TMP_PATH}/hosts ${SAMPLE_PATH}/hosts  >/dev/null 2>&1
    if [ $? -eq 0 ]
      then
        BACKUPSTATUS="${BACKUPSTATUS} hosts_check_OK"
      else
        cp ${TMP_PATH}/hosts ${SAMPLE_PATH}/hosts
        cp ${TMP_PATH}/hosts ${FILE_PATH}/${HHNAME}_${CHECKDATE}_hosts
        BACKUPSTATUS="${BACKUPSTATUS} hosts_check_False"
    fi

#    diff ${TMP_PATH}/kmtune ${SAMPLE_PATH}/kmtune  >/dev/null 2>&1
#    if [ $? -eq 0 ]
#      then
#        BACKUPSTATUS="${BACKUPSTATUS} kmtune_check_OK"
#      else
#        cp ${TMP_PATH}/kmtune ${SAMPLE_PATH}/kmtune
#        cp ${TMP_PATH}/kmtune ${FILE_PATH}/${HHNAME}_${CHECKDATE}_kmtune
#        BACKUPSTATUS="${BACKUPSTATUS} kmtune_check_False"
#    fi
       
  else
    cp /etc/passwd ${SAMPLE_PATH}/
    cp /etc/fstab ${SAMPLE_PATH}/
    cp /etc/hosts ${SAMPLE_PATH}/
#   $CMD >${SAMPLE_PATH}/kmtune 
    
    cp /etc/passwd ${FILE_PATH}/${HHNAME}_${CHECKDATE}_passwd
    cp /etc/fstab ${FILE_PATH}/${HHNAME}_${CHECKDATE}_fstab
    cp /etc/hosts ${FILE_PATH}/${HHNAME}_${CHECKDATE}_hosts
#    $CMD >${FILE_PATH}/${HHNAME}_${CHECKDATE}_kmtune
    BACKUPSTATUS="FILE BACKUP OK"
fi
     
echo "AAA_34 FileCheck;"${BACKUPSTATUS}    
