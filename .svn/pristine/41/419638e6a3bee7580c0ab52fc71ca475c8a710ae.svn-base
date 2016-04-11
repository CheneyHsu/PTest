#!/usr/bin/sh
#20120228 add sed 's/
//g'  window¸ñÊ½×ªlinux
#20120302 add ftp 10.1.32.1  tar -xf host8.87.tar
CHECKDATE=`date "+%Y-%m-%d"`
TMP_PATH=/hostinfo/hostinfo/tmp
PRLOG=/hostinfo/hostinfo/bin/prftp.log
date |tee -a ${PRLOG}
cd /hostinfo/hostinfo/log
#echo "Please Input Date (yyyy-dd-mm)"
#echo "DATE:"
#read CHECKDATE

cat /dev/null >${TMP_PATH}/maintab.log
cat /dev/null >${TMP_PATH}/diskinfo.log
cat /dev/null >${TMP_PATH}/ethernet.log
cat /dev/null >${TMP_PATH}/oracle.log
cat /dev/null >${TMP_PATH}/weblogic.log
cat /dev/null >${TMP_PATH}/vg.log
cat /dev/null >${TMP_PATH}/emc.log
cat /dev/null >${TMP_PATH}/dg.log
cat /dev/null >${TMP_PATH}/system_ver.log



for var in `ls *${CHECKDATE}.txt`
do

ABC=`cat ${var} |grep AAA |awk -F";" '{print $1="|"$2}'`
#HOSTNAME=`cat ${var}  |grep -w "AAA_1" |awk -F";" '{print $2}'`
#HOSTNAME="${var%%_*}"
echo "|TEST"${ABC}|sed "s/^/${CHECKDATE}/" |sed 's/
//g' >>${TMP_PATH}/maintab.log

grep -q "^4 " ${var}
if [ $? -eq 0 ]
  then
   cat ${var} |grep "^4" |grep -q "|"
   if [ $? -eq 0 ]
     then
  #    cat ${var} |awk -F";" '/^4/ {print $2}'|awk '{print $1"|"$2}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" >>${TMP_PATH}/system_ver.log
      cat ${var} |awk -F";" '/^4/ {print $2}'|awk -F"|" '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8}'| sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/system_ver.log
     else
      cat ${var} |awk -F";" '/^4/ {print $2}'|awk '{print $1"|"$2}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g' >>${TMP_PATH}/system_ver.log
  #    cat ${var} |awk -F";" '/^4/ {print $2}'|awk -F"|" '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8}'| sed "s/^/${CHECKDATE}|"${var%%_*}"|/" >>${TMP_PATH}/system_ver.log
   fi
fi


grep -q "^9" ${var}
if [ $? -eq 0 ]
  then 
      cat ${var} |grep "^9 " |grep -q "|"
      if [ $? -eq 0 ]
         then
    cat ${var} |awk -F";" '/^9/ {print $2}'| sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/diskinfo.log
         else
    cat ${var} |awk -F";" '/^9/ {print $2}'|awk '{print $1"|"$2}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/diskinfo.log
      fi
fi


grep -q "^10" ${var}
if [ $? -eq 0 ]
  then 
     cat ${var} |grep "^10 Eth" |grep -q "|"
	 if [ $? -eq 0 ]
	   then
    cat ${var} |awk -F";" '/^10 Eth/ {print $2}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" >>${TMP_PATH}/ethernet.log	      
	   else	   
    cat ${var} |awk -F";" '/^10/ {print $2}'|awk '{print $1"|"$2"|"$3}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/ethernet.log
      fi
fi

grep -q "^18" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^18/ {print $2}'|awk '{print $1"|"$2"|"$3}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/"|sed 's/
//g' >>${TMP_PATH}/oracle.log
fi

grep -q "^20" ${var}
if [ $? -eq 0 ]
  then
      cat ${var} |awk -F"[\"\"]" '/20 weblogic/ {print $1,$2,$3,$4,$5,$6}'|awk '{print $3"|"$5"|"$7}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/weblogic.log
       fi



grep -q "^27" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^27/ {print $2}'|awk '{print $1"|"$2"|"$3}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/"|sed 's/
//g' >>${TMP_PATH}/vg.log
fi

grep -q "^31" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^31/ {print $2}'|awk '{print $1"|"$6"|"$7}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/"|sed 's/
//g' >>${TMP_PATH}/emc.log
fi

grep -q "^32" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^32/ {print $2}'|awk '{print $1"|"$2"|"$3}' | sed "s/^/${CHECKDATE}|"${var%%_*}"|/" |sed 's/
//g'>>${TMP_PATH}/dg.log
fi

done


#2010-12-31 ADD

#DATALOG="/oracle/lhl/tmp"
#UPUSER="oracle"
#UPPASSWD="oracle"
#UPIP="10.1.18.151"



#ftp -n $UPIP <<EOF
#user  $UPUSER $UPPASSWD
#passive
#prompt off
#cd ${DATALOG}
#lcd ${TMP_PATH}
#mput *.log
#sleep 20
#bye
#EOF
