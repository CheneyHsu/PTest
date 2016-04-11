#!/usr/bin/sh
#���ù������ݴ����ű�
#���ռ������ĳ����������ݿ��ж�Ӧ������
#2013-7-31 ���û��������������Ľű�


CHECKDATE=`date "+%Y-%m-%d"`
export CHECKDATE
cd /hostinfo/hostinfo/data

#echo "Please Input Date (yyyy-dd-mm)"
#echo "DATE:"
#read CHECKDATE

TMP_PATH=/hostinfo/hostinfo/datatmp

#cat /dev/null >${TMP_PATH}/maintab.log
#cat /dev/null >${TMP_PATH}/diskinfo.log
#cat /dev/null >${TMP_PATH}/emc.log
#cat /dev/null >${TMP_PATH}/dg.log
#cat /dev/null >${TMP_PATH}/system_ver.log

rm -f /hostinfo/hostinfo/datatmp/*.log
rm -f /hostifno/check/log/*.txt
rm -f /hostinfo/check/log/errorlog/*.log
rm -f /hostinfo/pfccheck/log/*.txt

#��ѹ
if [ -f hostinfo_${CHECKDATE}_bak.tar ]
then
   echo "�ļ��Ѵ���"
tar rvf hostinfo_${CHECKDATE}_bak.tar  *${CHECKDATE}.tar.gz
else
tar cvf hostinfo_${CHECKDATE}_bak.tar  *${CHECKDATE}.tar.gz
tar uvf hostinfo_${CHECKDATE}_bak.tar  *${CHECKDATE}*.txt 
fi



/usr/contrib/bin/gzip -df *${CHECKDATE}*.tar.gz  
#��tar��
for var in `ls *${CHECKDATE}.tar`
do
  tar -xvf ${var}
done   

#������������
for var in `ls *${CHECKDATE}.txt`
do
  echo $var
  INFMODEL=`cat ${var} |awk -F";" '/^AAA_MODEL/ {print $NF}'`  #
  INFO01=`cat ${var} |awk -F";" '/^AAA_1 / {print $NF}'`  #������
  INFO02=`cat ${var} |awk -F";" '/^AAA_2 / {print $NF}'`  #�����ͺ� 
  INFO03=`cat ${var} |awk -F";" '/^AAA_3 / {print $NF}'`  #IP
  INFO04=`cat ${var} |awk -F";" '/^AAA_4 / {print $NF}'`  #ϵͳ�汾
  INFO05=`cat ${var} |awk -F";" '/^AAA_5 / {print $NF}'`  #cpu����
  INFO06=`cat ${var} |awk -F";" '/^AAA_6 / {print $NF}'`  #cpu�ͺ�
  INFO07=`cat ${var} |awk -F";" '/^AAA_7 / {print $NF}'`  #cpu��Ƶ
  INFO08=`cat ${var} |awk -F";" '/^AAA_8 / {print $NF}'`  #�ڴ�
  INFO09=`cat ${var} |awk -F";" '/^AAA_9 / {print $NF}'`  #���ش�������
  INFO10=`cat ${var} |awk -F";" '/^AAA_10/ {print $NF}'`  #��������
  INFO11=`cat ${var} |awk -F";" '/^AAA_11/ {print $NF}'`  #SCSI����
  INFO12=`cat ${var} |awk -F";" '/^AAA_12/ {print $NF}'`  #HBA ����
  INFO13=`cat ${var} |awk -F";" '/^AAA_13/ {print $NF}'`  #�Ŵ�������
  INFO14=`cat ${var} |awk -F";" '/^AAA_14/ {print $NF}'`  #cd����
  INFO15=`cat ${var} |awk -F";" '/^AAA_15/ {print $NF}'`  #�������к�
  INFO16=`cat ${var} |awk -F";" '/^AAA_16/ {print $NF}'`  #�洢���
  #INFO17=`cat ${var} |awk -F";" '/^AAA_17/ {print $NF}'`  #HBA�˿�
  #INFO18=`cat ${var} |awk -F";" '/^AAA_18/ {print $NF}'`  #oracle
  #INFO19=`cat ${var} |awk -F";" '/^AAA_19/ {print $NF}'`  #tuxedo
  #INFO20=`cat ${var} |awk -F";" '/^AAA_20/ {print $NF}'`  #weblogic
  INFO21=`cat ${var} |awk -F";" '/^AAA_21/ {print $NF}'`  #vcs
  INFO22=`cat ${var} |awk -F";" '/^AAA_22/ {print $NF}'`  #pci
  INFO23=`cat ${var} |awk -F";" '/^AAA_23/ {print $NF}'`  #Ӧ������
  INFO24=`cat ${var} |awk -F";" '/^AAA_24/ {print $NF}'`  #����ԱA
  INFO25=`cat ${var} |awk -F";" '/^AAA_25/ {print $NF}'`  #����ԱB 
  INFO26=`cat ${var} |awk -F";" '/^AAA_26/ {print $NF}'`  #Ӧ�ù���Ա
  INFO27=`cat ${var} |awk -F";" '/^AAA_27/ {print $NF}'`  #vg����
  INFO28=`cat ${var} |awk -F";" '/^AAA_28/ {print $NF}'`  #powerPtah�汾
  INFO29=`cat ${var} |awk -F";" '/^AAA_29/ {print $NF}'`   #SE�汾
  INFO30=`cat ${var} |awk -F";" '/^AAA_30/ {print $NF}'`  #Navisphere �汾
  INFO31=`cat ${var} |awk -F";" '/^AAA_31/ {print $NF}'`  #EMC ��������
  INFO32=`cat ${var} |awk -F";" '/^AAA_32/ {print $NF}'`  #DG ����
  INFO33=`cat ${var} |awk -F";" '/^AAA_33/ {print $NF}'`  #����  
   echo "${CHECKDATE}|${INFMODEL:-"TEST"}|${INFO01}|${INFO02}|${INFO03}|${INFO04}|${INFO05}|${INFO06}|${INFO07}|${INFO08}|${INFO09}|${INFO10}|${INFO11}|${INFO12}|${INFO13}|${INFO14}|${INFO15}|${INFO16}|${INFO21}|${INFO22}|${INFO23}|${INFO24}|${INFO26}|${INFO27}|${INFO28}|${INFO29}|${INFO30}|${INFO31}|${INFO32}|${INFO33}" |sed 's/
//g'  >>${TMP_PATH}/maintab.log
   INFMODEL="" 
   INFO01=""
   INFO02=""
   INFO03=""
   INFO04=""
   INFO05=""
   INFO06=""
   INFO07=""
   INFO08=""
   INFO09=""
   INFO10=""
   INFO11=""
   INFO12=""
   INFO13=""
   INFO14=""
   INFO15=""
   INFO16=""
   INFO21=""
   INFO22=""
   INFO23=""
   INFO24=""
   INFO25=""
   INFO26=""
   INFO27=""
   INFO28=""
   INFO29=""
   INFO30=""
   INFO31=""
   INFO32=""
   INFO33=""

#ϵͳ�汾   
grep -q "^4 " ${var}
if [ $? -eq 0 ]
  then
   cat ${var} |grep "^4" |grep -q "|"
   if [ $? -eq 0 ]
     then
      cat ${var} |awk -F";" '/^4/ {print $2}'|awk -F"|" '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8}'| sed "s/^/${CHECKDATE}|"${var%_*}"|/" |sed 's/
//g' >>${TMP_PATH}/system_ver.log
     else
      cat ${var} |awk -F";" '/^4/ {print $2}'|awk '{print $1"|"$2}' | sed "s/^/${CHECKDATE}|"${var%_*}"|/" |sed 's/
//g' >>${TMP_PATH}/system_ver.log
 fi
fi



grep -q "^9" ${var}
if [ $? -eq 0 ]
then 
  cat ${var} |grep "^9 " |grep -q "|"
  if [ $? -eq 0 ]
  then
    cat ${var} |awk -F";" '/^9/ {print $2}'| sed "s/^/${CHECKDATE}|"${var%_*}"|/"|sed 's/
//g' >>${TMP_PATH}/diskinfo.log
  else
    cat ${var} |awk -F";" '/^9/ {print $2}'|awk '{print $1"|"$2}' | sed "s/^/${CHECKDATE}|"${var%_*}"|/"|sed 's/
//g' >>${TMP_PATH}/diskinfo.log
  fi
fi




#EMC������Ϣ
grep -q "^31" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^31/ {print $2}'|awk '{print $1"|"$6"|"$7}' | sed "s/^/${CHECKDATE}|"${var%_*}"|/" >>${TMP_PATH}/emc.log
fi


#DG��Ϣ  
grep -q "^32" ${var}
if [ $? -eq 0 ]
  then 
    cat ${var} |awk -F";" '/^32/ {print $2}'|awk '{print $1"|"$2"|"$3}' | sed "s/^/${CHECKDATE}|"${var%_*}"|/" >>${TMP_PATH}/dg.log
fi  

done
#������maintab���Ĵ���
#Lpar ,Vpar,Vpar,VM
/hostinfo/hostinfo/bin/parstatus.sh &


#tuxedo info
/hostinfo/hostinfo/bin/tuxedoinfo.sh &

#�ļ�����
#for logname in "host_ip ethnet hbafcscsiinfo,tapeinfo,cdrominfo,kernelinfo,swapinfo,lvm_vg,lvm_lv,lvm_pv,softversion, oraclever,oracleuser,oracletbs,peizhiinfo"
for logname in `echo "host_ip ethnet hbafc scsiinfo tapeinfo cdrominfo kernelinfo swapinfo lvm_vg lvm_lv lvm_pv softversion oraclever oracleuser oracletbs oracleparameter peizhiinfo filesysteminfo diskboot sysenv vcs-haclusif vcs-haclus-ip vcs-haclus-sys vcs-haclus vcs-hasys vcs-hagrp vcs-hares vcs-hagrp-froze vcs-lltstat"`
do
  cat /dev/null >${TMP_PATH}/${logname}.log
  for var in `ls *${CHECKDATE}_${logname}.txt`
  do
    cat $var |sed 's/
//g' >>${TMP_PATH}/${logname}.log
  done
done  

#hosts  passwd group fstab
#
cat /dev/null >${TMP_PATH}/hosts.log
for varname in `ls *${CHECKDATE}_hosts.txt`
do
   #${varname%%_2*}
   cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/hosts.log
done   

#passwd
cat /dev/null >${TMP_PATH}/passwd.log
for varname in `ls *${CHECKDATE}_passwd.txt`
do
   #${varname%%_2*}
   cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/passwd.log
done  
 
#group
cat /dev/null >${TMP_PATH}/group.log
for varname in `ls *${CHECKDATE}_group.txt`
do
   #${varname%%_2*}
   cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/group.log
done  

#fstab
cat /dev/null >${TMP_PATH}/fstab.log
for varname in `ls *${CHECKDATE}_fstab.txt`
do
   #${varname%%_2*}
   cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/fstab.log
done  

#weblogic ��Ϣ����

#server 
for varname in `ls *${CHECKDATE}_*erver.txt`
do
   #${varname%%_2*}
   MY=`awk -F"|" 'NR==1 { print NF}' ${varname}`     #2i?4ND<~VPJG<8AP
   if [ $MY = 5 ];then
     cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'||"$0}' >>${TMP_PATH}/wlc_server.log
   else
      cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_server.log 
   fi  
done

#domain 
for varname in `ls *${CHECKDATE}_domain.txt`
do
   #${varname%%_2*}
   cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_domain.log
done
#jvm 
for varname in `ls *${CHECKDATE}_jvm.txt`
do
   #${varname%%_2*}
   MY=`awk -F"|" 'NR==1 { print NF}' ${varname}`     #2i?4ND<~VPJG<8AP
   if [ $MY = 5 ];then
      cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'||"$0}' >>${TMP_PATH}/wlc_jvm.log
   else
      cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_jvm.log
   fi	  
done
#webapp.txt 
for varname in `ls *${CHECKDATE}_webapp.txt `
do
   #${varname%%_2*}
     cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_webapp.log 
done
#webapp_target
for varname in `ls *${CHECKDATE}_webapp_target.txt `
do
   #${varname%%_2*}
   MY=`awk -F"|" 'NR==1 { print NF}' ${varname}`     #2i?4ND<~VPJG<8AP
   if [ $MY = 2 ];then   
     cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'||"$0}' >>${TMP_PATH}/wlc_webapp_target.log
   else
      cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_webapp_target.log 
   fi	  
done

#jdbc_target 
for varname in `ls *${CHECKDATE}_jdbc_target.txt `
do
   #${varname%%_2*}
   MY=`awk -F"|" 'NR==1 { print NF}' ${varname}`     #2i?4ND<~VPJG<8AP
   if [ $MY = 2 ];then    
     cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'||"$0}' >>${TMP_PATH}/wlc_jdbc_target.log
   else
     cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_jdbc_target.log
   fi
done
#jdbc 
for varname in `ls *${CHECKDATE}_jdbc.txt `
do
    cat ${varname} |awk '{print "'"${varname%_20*}|${CHECKDATE}"'|"$0}' >>${TMP_PATH}/wlc_jdbc.log 
done

# �û�������������
#abc=`cat ../conf/sysuservl.conf |grep -v "^#" |awk '{printf ("-e %s ",$0)}'`
#for varname in `ls *${CHECKDATE}*profile.txt |grep -v bash_profile`
#do
   #�����������ڣ��û�
#   HUSERNAME=`echo $varname |awk -F"_" '{print $1"|"$2"|"$3"|"}'`
#   cat $varname |grep $abc |sed 's/export //g' |awk -F";" '{print $1}'`
#done

#�û������������� 2013-07-31
#profile.txt
abc=`cat ../conf/sysuservl.conf |grep -v "^#" |awk '{printf ("-we %s ",$0)}'`
for varname in `ls *${CHECKDATE}*profile.txt |grep -v bash_profile`
do
    HUSERNAME=`echo $varname |awk -F"_" '{print $1"|"$2"|"$3"|"}'`
    cat $varname |grep -v "^#"|grep -v "alias" |grep $abc |sed 's/export //g'|sed 's/=/|/' |awk -F";" '{print "'$HUSERNAME'profile|"$1}' >>${TMP_PATH}/userenv.log   
done

#bash_profile.txt
abc=`cat ../conf/sysuservl.conf |grep -v "^#" |awk '{printf ("-we %s ",$0)}'`
for varname in `ls *${CHECKDATE}*bash_profile.txt`
do
    HUSERNAME=`echo $varname |awk -F"_" '{print $1"|"$2"|"$3"|"}'`
    cat $varname |grep -v "^#"|grep -v "alias" |grep $abc |sed 's/export //g'|sed 's/=/|/' |awk -F";" '{print "'$HUSERNAME'bash_profile|"$1}' >>${TMP_PATH}/userenv.log   
done

#bashrc.txt
abc=`cat ../conf/sysuservl.conf |grep -v "^#" |awk '{printf ("-we %s ",$0)}'`
for varname in `ls *${CHECKDATE}*bashrc.txt`
do
    HUSERNAME=`echo $varname |awk -F"_" '{print $1"|"$2"|"$3"|"}'`
    cat $varname |grep -v "^#"|grep -v "alias" |grep $abc |sed 's/export //g'|sed 's/=/|/' |awk -F";" '{print "'$HUSERNAME'bashrc|"$1}' >>${TMP_PATH}/userenv.log   
done




rm -f  /hostinfo/hostinfo/data/*${CHECKDATE}*.txt 
rm -f /hostinfo/hostinfo/data/*${CHECKDATE}.tar
rm -f /hostinfo/hostinfo/data/*filebak.tar
rm -f /hostinfo/hostinfo/data/*qiehuan.tar

#
cd /hostinfo/hostinfo/datatmp

tar cvf hostinfo.tar *.log  && gzip -f  hostinfo.tar 
ftp -v -n 10.1.32.1 <<EOF 
user smapp sm030211
prompt
bin
cd /files/system/SM/data
put hostinfo.tar.gz
bye  |tee -a  ${PRLOG}
EOF

