#!/bin/sh
if [ -d /oma/agent10g  -o  -d /oma/agent12c ]
then
su - oracle -c "/home/sysadmin/dba/clear_log/clear_single_ora.sh"
su - oracle -c "/home/sysadmin/dba/clear_log/clear_crs_ora10.sh"

cat /etc/passwd |grep grid > /dev/null 2>&1
if [ "$?" -eq 0 ]
then
su - oracle -c "/home/sysadmin/dba/clear_log/clear_crs_ora11.sh"
su - grid -c "/home/sysadmin/dba/clear_log/clear_asm_grid.sh"
fi


#ora and grid init
su - oracle -c "/home/sysadmin/dba/clear_log/ora_init.sh"


cat /etc/passwd |grep grid > /dev/null 2>&1
if [ "$?" -eq 0 ]
then
su - grid -c "/home/sysadmin/dba/clear_log/grid_init.sh"
fi

fi

echo 0