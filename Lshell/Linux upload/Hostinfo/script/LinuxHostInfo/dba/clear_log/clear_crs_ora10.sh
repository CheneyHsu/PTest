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

cd /home/sysadmin/dba/clear_log
cur_path=`pwd`

if [ -f ora_conf ]
then

. ./ora_conf
today=`date +%d`

if [ "$ORA_CRS" = "Y" ]
then


if [ "$dbversion" -eq 10 -o "$dbversion" -eq 9 ]
then

#############10G and 9I##############
#rm database log
for i in `seq 1 5`
  do  
      env|grep ORACLE_SID$i >/dev/null
        if [ "$?" -eq 0 ]
        then
			export ORACLE_SID=`env|grep ORACLE_SID$i|awk -F '=' '{print $2}'`
			export ORACLE_BASE=`env|grep ORACLE_BASE$i|awk -F '=' '{print $2}'`			
			
			
			#audit
			audit=`env|grep AUDIT$i|awk -F '=' '{print $2}'`
			
			
			if [ -d $audit ]
			then
			cd $audit
			
						
			if [ `ls $audit|wc -l` -gt 0 ]; then
			echo $audit > $cur_path/.audit_dirt
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche -f $cur_path/.audit_dirt	
			
			if [ "$?" -eq 0 ]
			then
			find ./ -name "*.aud" | xargs rm -rf  >/dev/null 2>&1
			fi
			
			fi
			fi
            
			cd  $ORACLE_BASE/admin/`echo $ORACLE_SID|sed 's/[0-9]\{1,\}$//g'`/
			#bdump
			if [ -d bdump ]
			then
			cd bdump
			
			ps -ef |grep ora_|grep -v grep |awk -F ' ' '{print $2 ,$NF}'|awk -F '_' '{if ($3="'$ORACLE_SID'") {print $0}}'|awk -F ' ' '{print $1}'> $cur_path/.ora_pid
			
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }' > $cur_path/.ora_trc
			
			for i in `cat $cur_path/.ora_pid`
			do
			
			cat $cur_path/.ora_trc |grep -v `echo $i` > $cur_path/.ora_trc_tmp
			cp $cur_path/.ora_trc_tmp $cur_path/.ora_trc
			
			done
			
			sh $cur_path/.ora_trc
			fi

			cd  $ORACLE_BASE/admin/`echo $ORACLE_SID|sed 's/[0-9]\{1,\}$//g'`/
			if [ -d bdump ]
			then
			cd bdump

			mv alert_$ORACLE_SID.log alert_`echo $ORACLE_SID`_`date +%Y%m%d`.log  >/dev/null 2>&1
			fi
			
			
			cd  $ORACLE_BASE/admin/`echo $ORACLE_SID|sed 's/[0-9]\{1,\}$//g'`/
			#bdump
			if [ -d bdump ]
			then
			cd bdump
			

			find ./ -name "alert*.log" -mtime +$ORA_DAY | xargs tar -cvf alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar >/dev/null 2>&1
			
			if [ "$?" -eq 0 ]
        	then
        	
        	if [ -f alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar ]
			then
			
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche $ORACLE_BASE/admin/$ORACLE_SID/bdump/alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar
						
			if [ "$?" -eq 0 ]
			then
			rm alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar >/dev/null 2>&1
			ls alert*.log |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			else
			rm alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			fi
			
			else
			sys_type=`uname -s`
			if [ "$sys_type" = "HP-UX" ]
			then
			rm alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			
			fi
			fi
			
			cd  $ORACLE_BASE/admin/`echo $ORACLE_SID|sed 's/[0-9]\{1,\}$//g'`/
			#cdump
			if [ -d cdump ]
			then
			cd cdump
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
			
			#udump
			if [ -d udump ]
			then
			cd udump
			
			ps -ef |grep -v root |grep -v grep|grep -v UID|awk -F ' ' '{print $2}' >$cur_path/.ora_upid
			
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }' >$cur_path/.ora_u_trc

			for i in `cat $cur_path/.ora_upid`
			do
			
			cat $cur_path/.ora_u_trc |grep -v `echo $i` > $cur_path/.ora_u_trc_tmp
			cp $cur_path/.ora_u_trc_tmp $cur_path/.ora_u_trc
			
			done
			
			sh $cur_path/.ora_u_trc
			
			fi
			
        fi

  done


#rm listener log
for i in `seq 1 5`
  do  
      env|grep TNS_NAME$i >/dev/null
        if [ "$?" -eq 0 ]
        then

        	export TNS_NAME=`env|grep TNS_NAME$i|awk -F '=' '{print $2}'`
        	cd $ORACLE_HOME/network/log/
        	        				
			#listener*.log
			
			BAK_TNS=`echo $TNS_NAME`_`date +%Y%m%d`.log			

ps -ef |grep tns |grep -v grep | grep -v root | awk '{print $(NF-1) }'|tr 'A-Z' 'a-z'|grep $TNS_NAME >/dev/null 2>&1
if [ "$?" -eq 0 ]
then		
lsnrctl<<EOF
set current_listener $TNS_NAME
set log_status off
EOF
fi
			
mv $TNS_NAME.log $BAK_TNS  >/dev/null 2>&1

ps -ef |grep tns |grep -v grep | grep -v root | awk '{print $(NF-1) }'|tr 'A-Z' 'a-z'|grep $TNS_NAME >/dev/null 2>&1
if [ "$?" -eq 0 ]
then
lsnrctl<<EOF
set current_listener $TNS_NAME
set log_status on
EOF
fi		
			
			find ./ -name "listener*.log" -mtime +$LSN_DAY | xargs tar -cvf `echo $TNS_NAME`_`date +%Y%m%d`.tar >/dev/null 2>&1
			
			if [ "$?" -eq 0 ]
			then
			
			if [ -f `echo $TNS_NAME`_`date +%Y%m%d`.tar ]
			then
				
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche $ORACLE_HOME/network/log/`echo $TNS_NAME`_`date +%Y%m%d`.tar
						
			if [ "$?" -eq 0 ]
			then
			rm `echo $TNS_NAME`_`date +%Y%m%d`.tar >/dev/null 2>&1
			ls listener*.log |awk '{print "find " $1 " -mtime +$LSN_DAY | xargs rm -rf " }'|sh
			else
			rm `echo $TNS_NAME`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			fi
			
			else
			sys_type=`uname -s`
			if [ "$sys_type" = "HP-UX" ]
			then
			rm `echo $TNS_NAME`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			fi

        fi

  done


#rm agent log

if [ -d /oma/agent10g/sysman/log ]
then

	cd /oma/agent10g/sysman/log
	
	agent_count=`ls emagent.trc*|wc -l`
	
	
	i=11
	while [ "$i" -lt "$agent_count" ]
	do
	rm emagent.trc.`echo $i`
	i=$(($i+1))
	done
fi


#rm CRS alert and client log

			cd /crs/log/`hostname`
			mv alert`hostname`.log alert`hostname`_`date +%Y%m%d`.log  >/dev/null 2>&1


			find ./ -name "alert*.log" -mtime +$ORA_DAY | xargs tar -cvf alert_`hostname`_`date +%Y%m%d`.tar >/dev/null 2>&1
			
			if [ "$?" -eq 0 ]
        	then
        	
        	if [ -f alert_`hostname`_`date +%Y%m%d`.tar ]
			then
			
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche /crs/log/`hostname`/alert_`hostname`_`date +%Y%m%d`.tar
						
			if [ "$?" -eq 0 ]
			then
			rm alert_`hostname`_`date +%Y%m%d`.tar >/dev/null 2>&1
			ls alert*.log |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			else
			rm alert_`hostname`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			fi
			
			else
			sys_type=`uname -s`
			if [ "$sys_type" = "HP-UX" ]
			then
			rm alert_`hostname`_`date +%Y%m%d`.tar >/dev/null 2>&1
			fi
			
			fi

			cd /crs/log/`hostname`
			#bdump
			if [ -d client ]
			then
			cd client
			
			ls |awk '{print "find " $1 " -mtime +$LSN_DAY | xargs rm -rf " }'|sh
			
			fi
			
			
fi
fi




fi