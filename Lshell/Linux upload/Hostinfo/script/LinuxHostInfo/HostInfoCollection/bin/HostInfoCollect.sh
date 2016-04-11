#!/bin/bash
#Linux 系统信息收集脚本

echo "Version V4.1   2014-06-15"

BAK=../bak
TMP_PATH=../tmp
CONF_PATH=../conf

date 
echo "AAA_MODEL;TEST"
echo "AAA_DATE;"$(date +"%Y-%m-%d %T %A %Z")   #20140410 
if [ $HHNAME ]
then
    echo "AAA_1 HOSTNAME;${HHNAME}"
else
    echo "AAA_1 HOSTNAME;"`hostname`
fi
echo "AAA_2 System Model;"`dmidecode|grep "Product Name"|head -1|awk -F":" '{print $2}'`

# 提取IP 如果配置文件中有就取配置文件中的IP
if [ -s /home/sysadmin/HostInfoCollection/conf/HOSTIP.txt ]
then
    AK=`cat /home/sysadmin/HostInfoCollection/conf/HOSTIP.txt`
	# AE=`netstat -in |grep ${AK} |wc -l`
	 AE=`ifconfig -a |sed -n '/^[b,e]/,+1'p  | sed -e 'N; s/\n/ /' |grep -v eth[0-9]: |grep -v bond[0-9]: |awk '/inet addr:/ {print substr($7,6)}' |grep -cw ${AK}`
    if [ ${AE} -gt 0 ]
    then
        echo "AAA_3 IP;"`cat /home/sysadmin/HostInfoCollection/conf/HOSTIP.txt`
    else
        echo "AAA_3 IP;"`ifconfig -a | grep 'inet ' | grep -v "127.0.0.1"| sed 's/^.*addr://g' | sed 's/Bcast.*$//g'` 
    fi
else
    echo "AAA_3 IP;"`ifconfig -a | grep 'inet ' | grep -v "127.0.0.1"| sed 's/^.*addr://g' | sed 's/Bcast.*$//g'` 
fi

grep -q SUSE /etc/issue
if [ $? -eq 0 ]
   then 
#     echo "AAA_4 System/Version;SUSE"`cat /etc/SuSE-release |awk -F"=" '/VERSION/ {print $2}'`"."`cat /etc/SuSE-release |awk -F"=" '/PATCHLEVEL/ {print $2}'`   
     echo "AAA_4 System/Version;SUSE"`cat /etc/SuSE-release |awk -F"=" '/VERSION/ {print $2}'`"."`cat /etc/SuSE-release |awk  '/PATCHLEVEL/ {print $NF}'`   

   else
     echo "AAA_4 System/Version;"`cat /etc/issue |grep -e release -e Server`
fi
echo "4 System/Version;"`uname -r`" "`getconf LONG_BIT`
#echo "AAA_5 Active processor;" `more /proc/cpuinfo |grep "model name"|wc -l;more /proc/cpuinfo |grep "cpu cores"|head -1`
echo "AAA_5 Active processor;"`more /proc/cpuinfo |grep "model name"|wc -l`":"`more /proc/cpuinfo |grep "cpu cores"|awk 'NR==1 {print $NF}'`
grep -q @ /proc/cpuinfo
if [ $? -eq 0 ]
  then 
    echo "AAA_6 processor model;"`more /proc/cpuinfo |grep 'model name'|head -1|sed 's/.*://g'|sed 's/@.*$//g'`
	echo "AAA_7 CPU Clock speed;"`cat /proc/cpuinfo |grep "cpu MHz" |awk 'NR==1 {printf "%2.1f\n",$NF / 1000}'`    #2012-4-20保存一位小数,单位G
 #   echo "AAA_7 CPU Clock speed;"`more /proc/cpuinfo |grep 'model name'|head -1|sed 's/.*@//g'`
  else
    echo "AAA_6 processor model;"`more /proc/cpuinfo |grep 'model name'|head -1|sed 's/.*://g'|sed 's/CPU.*$//g'`
    echo "AAA_7 CPU Clock speed;"`cat /proc/cpuinfo |grep "cpu MHz" |awk 'NR==1 {printf "%2.1f\n",$NF / 1000}'`    #2012-4-20保存一位小数,单位G
 #   echo "AAA_7 CPU Clock speed;"`more /proc/cpuinfo |grep 'model name'|head -1|sed 's/.*\(.\{7\}\)$/\1/'`
    
fi
echo "AAA_8 MEMORY;"`cat  /proc/meminfo |awk  '/MemTotal/{print $(NF-1) / 1024  }'`  #2012-4-20  单位MB  
#echo "AAA_8 MEMORY;"`more /proc/meminfo |grep 'MemTotal'|sed 's/.*://g'`
#查看磁盘信息
./swapinfo.sh
fdisk -l 2>&1|grep -q "Disk /dev/cciss"
if [ $? -eq 0 ]
  then
     echo "AAA_9 DSIK;"`fdisk -l 2>&1|grep  "Disk /dev/cciss*"|grep -v does|wc -l`
     fdisk -l 2>&1|grep "Disk /dev/cciss*" |grep -v does  |while read i
     do
       echo $i |awk '{print "9 Disk;"$2"|"$3}'
     done
   else
     echo "AAA_9 DSIK;"`fdisk -l 2>&1|grep -e "Disk /dev/sd" -e "Disk /dev/hd"|grep -v does|wc -l`
     fdisk -l 2>&1|grep -e "Disk /dev/cciss*" -e "Disk /dev/sd" -e "Disk /dev/hd"|grep -v does  |while read i
     do
       echo $i |awk '{print "9 Disk;"$2"|"$3}'
     done
fi


#文件系统收集
./filesystem.sh	
  
./ethnet.sh   #网卡信息	

echo "AAA_11 SCSI;"`lspci |grep "SCSI"|wc -l`
#./scsiinfo.sh
echo "AAA_12 HBA;"`lspci |grep "Fibre Channel"|wc -l`
./hbafc.sh
#lspci |grep "Fibre Channel"

echo "AAA_13 TAPE;NULL"
echo "AAA_14 DVD/CD;NULL"
#echo "AAA_15 machine serial number;"`dmidecode|grep "Serial Number" |head -1|awk -F":" '{print $2}'`
#echo "AAA_15 machine serial number;"`dmidecode  |grep -A8 "System Information"|awk '/Serial Number/ {print $NF}'`   #20130912
echo "AAA_15 machine serial number;"`dmidecode  |grep -A8 "System Information" |grep "Serial Number" |awk -F":" '{print $2}' |sed 's/^ //'`
if [ -x /usr/symcli/bin/symcfg ]
  then 
    echo "AAA_16 Storage Cabinet;"`/usr/symcli/bin/symcfg list | grep Local |awk '{print $1}'`
  else
    echo "AAA_16 Storage Cabinet;NULL"
fi

if [ -x /usr/symcli/bin/symmask ]
  then
    echo "AAA_17 HBA port;"`/usr/symcli/bin/symmask list hbas | grep Fibre`
  else
    echo "AAA_17 HBA port;NULL"
fi

ps -ef |grep -q [o]ra_smon
if [ $? -eq 0 ]
  then 
    ./oracle.sh
  else
    echo "AAA_18 oracle;NULL"
fi
#echo "AAA_19 Tuxedo;"`./TuxedoInfo.sh \`ps -ef |grep [B]BL |awk '{print $1}'\`|grep -e Version -e Release -e "==="`
#tuxedo
./tuxedo.sh
#echo "AAA_20 Weblogic;"`cat ${CONF_PATH}/appconf |grep -v "^#" |grep "weblogic"`
echo "AAA_21 VCS;"`rpm -aq|grep "VRTSvcs-"`
echo "AAA_22 PCI;NULL"
echo "AAA_23 AppName;"`cat ${CONF_PATH}/sysconf|awk -F: '/AppName/ {print $2}'`
echo "AAA_24 SysAdmin_A;"`cat ${CONF_PATH}/sysconf|awk -F: '/SysAdmin_A/ {print $2}'`
echo "AAA_25 SysAdmin_B;"`cat ${CONF_PATH}/sysconf|awk -F: '/SysAdmin_B/ {print $2}'`
echo "AAA_26 AppAdmin;"`cat ${CONF_PATH}/sysconf|awk -F: '/AppAdmin/ {print $2}'`

b=`fdisk -l 2>&1 |grep LVM |wc -l`
if [ $b -gt 0 ]
then
    echo "AAA_27 VG;"`vgdisplay |grep "VG Name"|wc -l`
    sh lvm_linux.sh    #201209929 修改
else
    echo "AAA_27 VG;NULL"
fi

#28 PowerPath Version Check
if [ -x /sbin/powermt ]
   then
     echo "AAA_28 PowerPath;"`/sbin/powermt version |awk -F"Version" '/Version/{print $2}'`
	  /sbin/powermt display dev=all >../file/powermtdisplay.txt         #20130715添加 收集Powermtpath信息
   else
     echo "AAA_28 PowerPath;NULL"
fi

#29 SolutionEnabler Version Check
if [ -x /usr/symcli/bin/symcli ]
  then 
     echo "AAA_29 SE Version;"`/usr/symcli/bin/symcli |awk -F"Version" '/Version/{print $2}'|head -1`
   else
     echo "AAA_29 SE Version;NULL"
fi

# 30 Navisphere Version
echo "AAA_30 Navisphere Version;"`rpm -qa |grep -i navi|head -1`
# 31 EMC Disk information
if [ -x /usr/symcli/bin/syminq ]
  then
    /usr/symcli/bin/syminq >${TMP_PATH}/emcdiskinfo.tmp 
    echo "AAA_31 EMC Disk;"`cat ${TMP_PATH}/emcdiskinfo.tmp |grep R2 |awk '!a[$6]++'|wc -l`
    cat ${TMP_PATH}/emcdiskinfo.tmp |grep -e R2 -e R1 |awk '!a[$6]++ '|awk '{print "31 EMC Disk;" $0}' 
   else
      echo "AAA_31 EMC Disk;NULL"
fi
# 32 DG information
DG_TMP=${TMP_PATH}/dg.tmp
if [ -x /usr/symcli/bin/symdg ]
  then 
    /usr/symcli/bin/symdg list|awk '/RDF/ {print $1}'> ${DG_TMP}
    echo "AAA_32 DG;"`cat ${DG_TMP}|wc -l`
   cat ${DG_TMP}  | while read i;
      do
         dg_name=${i}
         /usr/symcli/bin/symrdf -g ${dg_name} query  |awk '/^DEV/ {print "32 DG;","'${dg_name}'",$1,$2}'
 
      done
   else 
      echo "AAA_32 DG;NULL"
 fi
echo "AAA_33 APP;"`cat ${CONF_PATH}/appconf |grep -v "^#" |grep -v "weblogic"`

#vcs检查
if [ `/opt/VRTSvcs/bin/hasys -state | grep RUNNING | wc -l ` -gt 0 ]
then
    ./vcsinfo.sh
fi

#环境变量信息 2013-06-06
./sysenv.sh

./sysfilebak.sh
./qiehuan.sh
#内核文件备份
./kernelinfo.sh
#软件版本 
./softversion.sh
#weblogic信息收集

sh CollWlcinfo.sh  2>&1 >/dev/null
./cron.sh 
#主备机配置信息 
./peizhiinfo.sh 

ps -efx >../file/ps-ef.txt  2>&1

rpm -qa >../file/syssoft.txt 2>&1

echo "AAA_00;BBBAA"
date
