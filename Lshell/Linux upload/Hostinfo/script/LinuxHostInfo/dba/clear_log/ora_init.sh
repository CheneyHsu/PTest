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

if [ -d /home/sysadmin/dba/clear_log ]
then
cd /home/sysadmin/dba/clear_log
else
echo "Please create /home/sysadmin/dba/clear_log directory."
exit
fi

cd /home/sysadmin/dba/clear_log
cur_path=`pwd`

if [ ! -f ora_conf ]
then
cd /home/sysadmin/dba/clear_log
ps -ef |grep smon |grep -v grep |awk '{print $NF }'|grep ^ora |awk -F '_' '{if ($3==$NF) {print $3} else {print $3"_"$4}}' >.sid_conf
sid_count=`cat .sid_conf|wc -l`


ps -ef |grep tns |grep -v grep | grep -v root | awk '{print $(NF-1) }'|tr 'A-Z' 'a-z' >.tns_conf
tns_count=`cat .tns_conf|wc -l`


if [ "$sid_count" -ge 1 -a "$tns_count" -ge 1 ]
then

#database config
i=1
while [ "$i" -le "$sid_count" ]
do
sed -n ''$i','$i'p' .sid_conf |sed 's/^/export ORACLE_SID'$i'=/g' >> ora_conf

sed -n ''$i','$i'p' .sid_conf |sed 's/^/export ORACLE_SID=/g' >.config
. ./.config


echo export ORACLE_BASE`echo $i`=`echo $ORACLE_BASE` >> ora_conf


sqlplus -S '/ as sysdba' <<EOF
set pagesize 0 feedback off heading off linesize 180
spool .audit
select value from v\$parameter where name='audit_file_dest';
spool off
EOF

#audit
echo export AUDIT`echo $i`=`grep -v ^$ .audit` >> ora_conf


        i=$(($i+1))
done



#listener config
i=1
while [ "$i" -le "$tns_count" ]
do
sed -n ''$i','$i'p' .tns_conf |sed 's/^/export TNS_NAME'$i'=/g' >> ora_conf

        i=$(($i+1))
done

echo export dbversion=`sqlplus -v |grep -v  ^$|awk -F ' ' '{print $3}'|awk -F '.' '{print $1}'` >>ora_conf
echo export GORACLE_BASE=`echo $ORACLE_BASE` >> ora_conf
echo export GORACLE_HOME=`echo $ORACLE_HOME` >> ora_conf
echo export ORA_DAY=15 >> ora_conf
echo export LSN_DAY=15 >> ora_conf


ps -ef |grep ocssd.bin|grep -v grep  >/dev/null 2>&1
if [ "$?" -eq 0 ]
then
echo export ORA_CRS=Y >> ora_conf
else
echo export ORA_CRS=N >> ora_conf
fi


echo
echo
echo " The initial configuration information is completed."



else
echo
echo " Please start the database and listener to re run the script."
echo
fi

fi