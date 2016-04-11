#!/bin/sh
############################
#define func seq for aix&hp-unix
#fun name seq
#date 2014 4 25
############################
seq(){
i=$1
while [ "$i" -le "$2" ]
do
        echo "$i"
        i=$(($i+1))
done
}

#init script

cd /home/sysadmin/dba/clear_log


if [ ! -f grid_conf ]
then

ps -ef |grep smon |grep -v grep |awk '{print $NF }'|grep ^asm |awk -F '_' '{if ($3==$NF) {print $3} else {print $3"_"$4}}' >.grid_sid_conf
grid_sid_count=`cat .grid_sid_conf|wc -l`

ps -ef |grep tns |grep -v grep | grep -v root | awk '{print $(NF-1) }'|tr 'A-Z' 'a-z' >.grid_tns
grid_tns_count=`cat .grid_tns|wc -l`

ps -ef |grep ocssd.bin|grep -v grep  >/dev/null 2>&1

if [ "$?" -eq 0 -a "$grid_tns_count" -ge 1  -a "$grid_sid_count" -ge 1 ]
then

i=1
while [ "$i" -le "$grid_sid_count" ]
do
sed -n ''$i','$i'p' .grid_sid_conf |sed 's/^/export ORACLE_GSID'$i'=/g' >> grid_conf

sed -n ''$i','$i'p' .grid_sid_conf |sed 's/^/export ORACLE_GSID=/g' >.grid_config
. ./.grid_config


sqlplus -S '/ as sysdba' <<EOF
set pagesize 0 feedback off heading off linesize 180
spool .grid_audit
select value from v\$parameter where name='audit_file_dest';
spool off
EOF

#audit
echo export GAUDIT`echo $i`=`grep -v ^$ .grid_audit` >> grid_conf


        i=$(($i+1))
done




#listener config
i=1
while [ "$i" -le "$grid_tns_count" ]
do
sed -n ''$i','$i'p' .grid_tns |sed 's/^/export GTNS_NAME'$i'=/g' >> grid_conf

        i=$(($i+1))
done

echo export dbversion=`sqlplus -v |grep -v  ^$|awk -F ' ' '{print $3}'|awk -F '.' '{print $1}'` >>grid_conf
echo export ORA_DAY=15 >> grid_conf
echo export LSN_DAY=15 >> grid_conf
echo export CRS_BASE=`echo $ORACLE_BASE` >> grid_conf
echo export CRS_HOME=`echo $ORACLE_HOME` >> grid_conf
echo export ORA_CRS=Y >> grid_conf


echo
echo
echo " The grid initial configuration information is completed."


else
echo
echo " Please start the CRS and listener to re run the script."
echo
fi
fi