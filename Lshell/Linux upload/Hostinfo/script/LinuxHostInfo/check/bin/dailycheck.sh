#!/bin/bash
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/opt/gnome/sbin:/root/bin:/usr/local/bin:/usr/bin:/usr/X11R6/bin:/bin:/usr/games:/opt/gnome/bin:/opt/kde3/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin

#清空系统检查表的数据
cat /dev/null > ../file/${HHNAME}_${CHECKDATE}_system.txt

date
echo "----------------------------------------------------------"
echo
echo "HostIP;"`ifconfig -a | grep 'inet ' | grep -v "127.0.0.1"| sed 's/^.*addr://g' | sed 's/Bcast.*$//g'`
echo
./01_syslog_check.sh	# SYSLOG Check

./02_badlogin_check.sh	# Bad Login Check

./03_hardware_check.sh	# Hardware Check

./05_cfg_group_check.sh 	# /etc/group Check

./06_cfg_hosts_check.sh	# /etc/hosts Check

./07_cfg_passwd_check.sh	# /etc/passwd Check

#./08_cfg_kernel_check.sh	# Kernel Configuration Check

./09_ntpq_check.sh 

./10_vg_check.sh		# Volume Group Check

./11_filesystem_check.sh	# Filesystems Check

./12_swap_check.sh		# Swap Check

./13_network_check.sh	# Network Check


if [ -x /opt/OV/bin/opctemplate ]
  then
    ./15_ovo_check.sh     #OVO Check
#  else
#   echo  "15 OVO Check :"
#   echo "................................Not.Check" | awk '{printf "%60s\n",$1}'
#   echo "----------------------------------------------------------"
fi

ps -ef |grep -q [o]ra_smon
a=$?
if [ $a = 0 ]
  then
    ./16_oracle_log_check.sh   # Oracle Log Check
    ./17_oracle_listener_check.sh     # listener.ora Check
    ./18_oracle_lsnrctl_check.sh       # Oracle Listener Check
    ./19_oracle_usage_check.sh        # Oracle Usage Check
#  else
#    echo  "16 Oracle Log Check:"
#    echo "............................Not.Check" | awk '{printf "%60s\n",$1}'
#    echo
#    echo  "17 listener.ora Check :"
#    echo "............................Not.Check" | awk '{printf "%60s\n",$1}'
#    echo
#    echo  "18 Oracle lsnrctl Check :"
#    echo "............................Not.Check" | awk '{printf "%60s\n",$1}'
#    echo
#    echo  "19 Oracle Usage Check :"
#    echo "............................Not.Check" | awk '{printf "%60s\n",$1}'
#    echo "----------------------------------------------------------"
fi



./20_vcs_check.sh      # Cluster Check

#./network_log_check.sh  # Network Log Check

#./setboot_check.sh


if [ -x /sbin/powermt ]
  then
    ./21_powerpath_check.sh    # PowerPath Check
#  else
#    echo  "21 PowerPath Check :"
#    echo ".................................Not..Check" | awk '{printf "%60s\n",$1}'
#    echo
#    echo "----------------------------------------------------------"
fi




if [ -x /usr/symcli/bin/symrdf ]
  then
    ./22_srdf_check.sh         # SRDF Check
#  else
#    echo  "22 SRDF Check :"
#    echo ".................................Not.Check" | awk '{printf "%60s\n",$1}'
#    echo
#    echo "----------------------------------------------------------"
fi

./23_nbu_check.sh

./24_cron_check.sh
./25_cfg_fstab.sh
./26_cfg_profile.sh
#./27_core.sh
./28_zombie.sh
./30_inittab_check.sh

# 31 APP 
if [ -f /home/sysadmin/check/app/*.txt ]
  then 
   echo "31 APP:"
   echo `cat /home/sysadmin/check/app/*.txt |grep -v "^#"`
  else
    echo "31 APP Files NULL:"
fi

echo "----------------------------------------------------------"

# 32 VCS configuration check
A=`date "+%a"`
if [ $A = Mon ]
  then
    ps -ef |grep -q [h]ashadow
    if [ $? -eq 0 ]
      then
        sh 32_vcs_chkcfg.sh >${ERRORLOG_PATH}/${CHECKDATE}_chkcfg.out 2>&1
        if [ $? -eq 0 ]
          then
            echo  "32 VCS configuration check"
            echo ".................................OK" | awk '{printf "%60s\n",$1}'
          else
            echo  "32 VCS configuration check"
            echo ".................................False" | awk '{printf "%60s\n",$1}'
         fi
        else
          echo  "32 VCS configuration check"
          echo "...................................NOT_running" | awk '{printf "%60s\n",$1}'
     fi
   else
     echo  "32 VCS configuration check"
     echo "...................................NOT_Mon" | awk '{printf "%60s\n",$1}'
fi

./35_ip_check.sh
./36_autoagent.sh

echo "----------------------------------------------------------"
