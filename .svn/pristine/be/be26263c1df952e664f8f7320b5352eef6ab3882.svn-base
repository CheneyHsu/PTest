#!/bin/sh
export LANG=C
BIN_PATH=/home/sysadmin/pfc_check/bin
TMP_PATH=/home/sysadmin/pfc_check/tmp
SETUP_PATH=/home/sysadmin/pfc_check/bin
CHECKDATE=`date "+%Y-%m-%d"`


#setting  crontab  2012-07-06 修改   如果是Linux系统crontab 就加到root中
if [ `uname -s` = "Linux" ]
then 
    crontab -u root -l |grep -q "/home/sysadmin/pfc_check/bin/pfc_check.sh"
    if [ $? -ne 0 ]
      then
        crontab -u root -l > ${TMP_PATH}/${CHECKDATE}_crontab.bak
        cp  ${TMP_PATH}/${CHECKDATE}_crontab.bak ${TMP_PATH}/${CHECKDATE}_crontab.new
        echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * *  /home/sysadmin/pfc_check/bin/pfc_check.sh >/dev/null 2>&1 " >>${TMP_PATH}/${CHECKDATE}_crontab.new
        crontab -u root ${TMP_PATH}/${CHECKDATE}_crontab.new
      else
        echo "@@  crontab OK  @@"
    fi
    
    crontab -u root -l |grep -q "/home/sysadmin/pfc_check/bin/pfc_check.sh"
    if [ $? -ne 0 ]
      then
        echo "@@  crontab set up to fail  @@"
      else
        echo "@@  crontab set up a successful @@"
    fi

else
       
    crontab -l |grep -q "/home/sysadmin/pfc_check/bin/pfc_check.sh"
    if [ $? -ne 0 ]
      then
        crontab -l > ${TMP_PATH}/${CHECKDATE}_crontab.bak
        cp  ${TMP_PATH}/${CHECKDATE}_crontab.bak ${TMP_PATH}/${CHECKDATE}_crontab.new
        echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * *  /home/sysadmin/pfc_check/bin/pfc_check.sh >/dev/null 2>&1 " >>${TMP_PATH}/${CHECKDATE}_crontab.new
        crontab  ${TMP_PATH}/${CHECKDATE}_crontab.new
      else
        echo "@@  crontab OK  @@"
    fi
    
    crontab -l |grep -q "/home/sysadmin/pfc_check/bin/pfc_check.sh"
    if [ $? -ne 0 ]
      then
        echo "@@  crontab set up to fail  @@"
      else
        echo "@@  crontab set up a successful @@"
    fi    
fi