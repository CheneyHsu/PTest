#!/bin/bash
export LANG=C
BIN_PATH=/home/sysadmin/check/bin
SAMPLE_PATH=../sample
TMP_PATH=/home/sysadmin/check/tmp
CONF_PATH=../conf
SETUP_PATH=/home/sysadmin/check/setup
CHECKDATE=`date "+%Y-%m-%d"`

cd /home/sysadmin/check/setup

#setting  crontab 
crontab -u root -l |grep -q "/home/sysadmin/check/bin/Upload.sh"
if [ $? -ne 0 ]
  then
    crontab -u root -l > ${TMP_PATH}/${CHECKDATE}_crontab.bak
    cp  ${TMP_PATH}/${CHECKDATE}_crontab.bak ${TMP_PATH}/${CHECKDATE}_crontab.new
    echo "`date "+%M"` 7 * * * /home/sysadmin/check/bin/Upload.sh > /dev/null 2>&1 " >>${TMP_PATH}/${CHECKDATE}_crontab.new
    crontab -u root ${TMP_PATH}/${CHECKDATE}_crontab.new
  else
    echo "@@  crontab OK  @@"
fi

crontab -u root -l |grep -q "/home/sysadmin/check/bin/Upload.sh"
if [ $? -ne 0 ]
  then
    echo "@@  crontab set up to fail  @@"
  else
    echo "@@  crontab set up a successful @@"
fi


#ANS=Y
#while [ $ANS = Y -o $ANS = y ]
#do

echo "    ##########################################"
echo "    #  Setting conf                          #"
echo "    ##########################################"
echo "    #  011  011_syslog_check_set.sh          #"
echo "    #  111  111_filesystem_check_set.sh      #"  
echo "    #  121  121_swap_check_set.sh            #"  
echo "    #  161  161_oracle_log_check_set.sh      #"   
echo "    #  161  161_oracle_log_except_set.sh     #"   
echo "    #  171  171_oracle_listener_check_set.sh #"  
echo "    #  181  181_oracle_lsnrctl_check_set.sh  #"  
echo "    #  191  191_oracle_usage_check_set.sh    #"  
echo "    #  221  221_srdf_check_set.sh            #"  
echo "    ##########################################"
echo "    #  Initialize Configuration              #"
echo "    ##########################################"
echo "    #  032  032_hardware_init.sh            #"
echo "    #  052  052_cfg_group_init.sh            #"  
echo "    #  062  062_cfg_hosts_init.sh            #"  
echo "    #  072  072_cfg_passwd_init.sh           #"  
echo "    #  082  082_cfg_kernel_init.sh           #"  
echo "    #  102  102_vg_init.sh                   #"  
echo "    #  132  132_network_init.sh              #"  
echo "    #  152  152_ovo_init.sh                  #"  
echo "    #  172  172_oracle_listener_init.sh      #"  
echo "    #  182  182_oracle_lsnrctl_init.sh       #"  
echo "    #  202  202_vcs_init.sh                  #"
echo "    #  212  212_powerpath_init.sh            #"  
echo "    #  222  222_srdf_init.sh                 #"  
echo "    #  242  242_cron.init.sh                 #"  
echo "    #  252  252_cfg_fstab_init.sh            #"  
echo "    #  262  262_cfg_profile.sh               #"  
echo "    #  302  302_inittab.sh                   #"  
echo "    ##########################################"  
echo "    #  ALL   All                             #" 
echo "    #  exit  EXIT                            #"
echo "    ##########################################"
echo
echo "Please input "
echo "Number"
read nuvalue

case ${nuvalue} in
   011)
       ../set/011_syslog_check_set.sh ;;
   111)
       ../set/111_filesystem_check_set.sh ;;
   121)
       ../set/121_swap_check_set.sh ;;
   161)
       ../set/161_oracle_log_check_set.sh 
       ../set/161_oracle_log_except_set.sh ;;
   171)
       ../set/171_oracle_listener_check_set.sh ;;
   181)
       ../set/181_oracle_lsnrctl_check_set.sh ;;  
   191)
       ../set/191_oracle_usage_check_set.sh ;;
   221)
       ../set/221_srdf_check_set.sh ;;
   032)
       ../init/032_hardware_init.sh ;;
   052)
       ../init/052_cfg_group_init.sh ;;
   062)
       ../init/062_cfg_hosts_init.sh ;; 
   072)
       ../init/072_cfg_passwd_init.sh ;; 
#   082)
#       ../init/082_cfg_kernel_init.sh ;;
   102)
       ../init/102_vg_init.sh ;;
   132)
       ../init/132_network_init.sh ;; 
   152)
       ../init/152_ovo_init.sh ;;
   172)
       ../init/172_oracle_listener_init.sh ;;
   182)
       ../init/182_oracle_lsnrctl_init.sh ;; 
   202)
       ../init/202_vcs_init.sh ;;
   212)
       ../init/212_powerpath_init.sh ;;
   222)
       ../init/222_srdf_init.sh ;;
   242)
       ../init/242_cron.init.sh ;;
   252)
       ../init/252_cfg_fstab_init.sh ;;
   262)
       ../init/262_cfg_profile.sh ;;
   302)
       ../init/302_inittab.sh ;;
   ALL|all)

../set/011_syslog_check_set.sh
../set/111_filesystem_check_set.sh
../set/121_swap_check_set.sh

ps -ef |grep -q [o]ra_smon
a=$?
if [ $a = 0 ]
  then 
   ../set/161_oracle_log_check_set.sh
   ../set/161_oracle_log_except_set.sh
   ../set/171_oracle_listener_check_set.sh
   ../set/181_oracle_lsnrctl_check_set.sh
   ../set/191_oracle_usage_check_set.sh
  else
    echo  "161 oracle_log_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "171 oracle_listener_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "181 oracle_lsnrctl_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "191 oracle_usage_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo

fi



if [ -x /usr/symcli/bin/symrdf ]
  then
    ../set/221_srdf_check_set.sh
  else
    echo  "221 srdf_check.conf :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

echo "##########################################"
echo "#  Initialize  Configuration              "
echo "##########################################"

../init/032_hardware_init.sh
../init/052_cfg_group_init.sh
../init/062_cfg_hosts_init.sh
../init/072_cfg_passwd_init.sh
#../init/082_cfg_kernel_init.sh
../init/102_vg_init.sh
../init/132_network_init.sh


ps -ef |grep -q [o]ra_smon
a=$?
if [ $a = 0 ]
  then
   ../init/172_oracle_listener_init.sh
   ../init/182_oracle_lsnrctl_init.sh
  else
    echo  "172_oracle_listener_init.sh :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "182_oracle_lsnrctl_init.sh :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
   echo
fi
ps -ef |grep -q [o]vcd
if [ $? -eq 0 ]
  then 
    ../init/152_ovo_init.sh
  else
    echo  "152_ovo_init.sh :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

../init/202_vcs_init.sh



if [ -x /sbin/powermt ]
  then
    ../init/212_powerpath_init.sh
  else
    echo  "212_powerpath_init.sh :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

if [ -x /usr/symcli/bin/symrdf ]
  then
    ../init/222_srdf_init.sh
  else
    echo  "222_srdf_init.sh :"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi
../init/242_cron.init.sh
../init/252_cfg_fstab_init.sh
../init/262_cfg_profile.sh
../init/302_inittab.sh
;;

 EXIT|exit)
      exit;;
        *)
       echo "Input error";;
esac
#  echo "Continue (Y/y)"
#  read ANS
#done

