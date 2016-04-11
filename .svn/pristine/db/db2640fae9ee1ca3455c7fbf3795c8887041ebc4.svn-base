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

if [ -f ora_conf -a -f grid_conf ]
then

. ./ora_conf
. ./grid_conf
today=`date +%d`

if [ "$ORA_CRS" = "Y" ]
then

if [ "$dbversion" -eq 11 ]
then

#############11G#############
#rm database log
for i in `seq 1 5`
  do  
      env|grep ORACLE_GSID$i >/dev/null
        if [ "$?" -eq 0 ]
        then
        	export ORACLE_SID=`env|grep ORACLE_GSID$i|awk -F '=' '{print $2}'`
     		
						
			#audit
			audit=`env|grep GAUDIT$i|awk -F '=' '{print $2}'`
			if [ -d $audit ]
			then
			cd $audit
			
						
			if [ `ls $audit|wc -l` -gt 0 ]; then
			echo $audit > $cur_path/.gaudit_dirt
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche -f $cur_path/.gaudit_dirt 
						
			if [ "$?" -eq 0 ]
			then
			find ./ -name "*.aud" | xargs rm -rf  >/dev/null 2>&1
			fi
			
			fi
			fi
			
			cd  $ORACLE_BASE/diag/asm/`echo $ORACLE_SID|tr 'A-Z' 'a-z'|sed 's/[0-9]\{1,\}$//g'`/$ORACLE_SID/
			#incident
			if [ -d incident ]
			then
			cd incident
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			cd ../
			fi

			#alert xml
			if [ -d alert ]
			then
			cd alert
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
			
			#cdump
			if [ -d cdump ]
			then
			cd cdump
			ls |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
			
			#trace and alert*.log
			if [ -d trace ]
			then
			cd trace

			ps -ef |grep -v root |grep -v grep|grep -v UID|awk -F ' ' '{print $2}' > $cur_path/.grid_pid


			ls *.trc |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }' > $cur_path/.grid_trc
			ls *.trm |awk '{print "find " $1 " -mtime +$ORA_DAY | xargs rm -rf " }' > $cur_path/.grid_trm
			
			for i in `cat $cur_path/.grid_pid`
			do
			
			cat $cur_path/.grid_trc |grep -v `echo $i` > $cur_path/.grid_trc_tmp
			cat $cur_path/.grid_trm |grep -v `echo $i` > $cur_path/.grid_trm_tmp
			
			cp $cur_path/.grid_trc_tmp $cur_path/.grid_trc
			cp $cur_path/.grid_trm_tmp $cur_path/.grid_trm
			
			done
			
			sh $cur_path/.grid_trc
			sh $cur_path/.grid_trm
			
			fi

			
			cd  $ORACLE_BASE/diag/asm/`echo $ORACLE_SID|tr 'A-Z' 'a-z'|sed 's/[0-9]\{1,\}$//g'`/$ORACLE_SID/
			if [ -d trace ]
			then
			cd  trace
			mv alert_$ORACLE_SID.log alert_`echo $ORACLE_SID`_`date +%Y%m%d`.log  >/dev/null 2>&1
			
			fi
			
			
			cd  $ORACLE_BASE/diag/asm/`echo $ORACLE_SID|tr 'A-Z' 'a-z'|sed 's/[0-9]\{1,\}$//g'`/$ORACLE_SID/
			if [ -d trace ]
			then
			cd trace
			
			find ./ -name "alert*.log" -mtime +$ORA_DAY | xargs tar -cvf alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar >/dev/null 2>&1
			
			if [ "$?" -eq 0 ]
        	then
        	
        	if [ -f alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar ]
			then
			
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche   $ORACLE_BASE/diag/rdbms/`echo $ORACLE_SID|tr 'A-Z' 'a-z'`/$ORACLE_SID/trace/alert_`echo $ORACLE_SID`_`date +%Y%m%d`.tar
						
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


        fi

  done


#rm listener log
for i in `seq 1 5`
  do  
      env|grep GTNS_NAME$i >/dev/null
        if [ "$?" -eq 0 ]
        then

        	export TNS_NAME=`env|grep GTNS_NAME$i|awk -F '=' '{print $2}'`
        	
        	echo $TNS_NAME|grep -i SCAN >/dev/null 2>&1
        	
        	if [ "$?" -eq 0 ]
        	then
        	cd $CRS_HOME/log/diag/tnslsnr/`hostname`/`echo $TNS_NAME`
        	else
        	cd $GORACLE_BASE/diag/tnslsnr/`hostname`/`echo $TNS_NAME`
        	fi
        	
        	#incident
			if [ -d incident ]
			then
			cd incident
			ls |awk '{print "find " $1 " -mtime +$LSN_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
			
			#alert xml
			if [ -d alert ]
			then
			cd alert
			ls |awk '{print "find " $1 " -mtime +$LSN_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
			
			#cdump
			if [ -d cdump ]
			then
			cd cdump
			ls |awk '{print "find " $1 " -mtime +$LSN_DAY | xargs rm -rf " }'|sh
			cd ../
			fi
			
		
			#listener*.log
			if [ -d trace ]
			then
			cd trace
			
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
					
			cd ../
			fi
			

        	echo $TNS_NAME|grep -i SCAN >/dev/null 2>&1
        	if [ "$?" -eq 0 ]
        	then
        	cd $CRS_HOME/log/diag/tnslsnr/`hostname`/`echo $TNS_NAME`
        	else
        	cd $GORACLE_BASE/diag/tnslsnr/`hostname`/`echo $TNS_NAME`
        	fi
			
			if [ -d trace ]
			then
			cd trace
			
			find ./ -name "listener*.log" -mtime +$LSN_DAY | xargs tar -cvf `echo $TNS_NAME`_`date +%Y%m%d`.tar >/dev/null 2>&1
			
			if [ "$?" -eq 0 ]
			then
			
			if [ -f `echo $TNS_NAME`_`date +%Y%m%d`.tar ]
			then
			
			/usr/openv/netbackup/bin/bpbackup -p DBA-dbs-dblog-pri-bp -h `hostname`_nbu -s DBA-dbs-dblog-pri-bp-sche $ORACLE_BASE/diag/tnslsnr/`hostname`/`echo $TNS_NAME`/trace/`echo $TNS_NAME`_`date +%Y%m%d`.tar
			
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
        fi
  done

fi

fi
fi