#!/bin/bash

./032_hardware_check.sh
./052_cfg_group_init.sh
./062_cfg_hosts_init.sh
./072_cfg_passwd_init.sh
./082_cfg_kernel_init.sh
./102_vg_init.sh
./132_network_init.sh

ps -ef |grep -q [o]ra_smon
a=$?
if [ $a = 0 ]
  then
   ./172_oracle_listener_init.sh
   ./182_oracle_lsnrctl_init.sh
  else
    echo  "172 Oracle listener Initialization:"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
    echo  "182 oracle lsnrctl Initialization:"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

if [ -x /opt/OV/bin/opctemplate ]
  then 
    ./152_ovo_init.sh
  else
    echo  "152 OVO Initialization:"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi


#./202_cluster_init.sh


if [ -x /sbin/powermt ]
  then
    ./212_powerpath_init.sh
  else
    echo  "212 powerpath_init.sh Initialization:"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

if [ -x /usr/symcli/bin/symrdf ]
  then
    ./222_srdf_init.sh
  else
    echo  "222 srdf_init.sh Initialization:"
    echo "...................................False" | awk '{printf "%60s\n",$1}'
    echo
fi

