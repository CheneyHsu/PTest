#!/bin/sh

TUX_USERS=`ps -ef|grep -w BBL | grep -v grep | awk '{ print $1}'`
FILE_TIMESTAMP=$(date +%Y-%m-%d)

if [ -n ${TUX_USERS} ]; then
   for TUX_USER in ${TUX_USERS}
   do
   su - ${TUX_USER} -c "sh /home/sysadmin/tuxedo_check/bin/tux_data_collector.sh ${TUX_USER} ${FILE_TIMESTAMP}"
   done
else
   echo "The BBL process doesn't exist !"
fi
