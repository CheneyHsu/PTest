#!/bin/bash

gbl_var_init()
{
  # Script version
  VERSION="0.2"
  #Current date
  DATE=`date +%Y%m%d`
  #Current time
  TIME=`date +%H:%M:%S`
  #Current time without ":"
  TIMEHMS=`date +%H%M%S`
  #hostname
  HOSTNAME=`hostname`
  #DB2_INSTALL_PATH
  INSTALL_PATH=`/usr/local/bin/db2ls | grep 0 | awk '{print $1}'`
  #configuration
  CONFFILE="ref.conf"
  #backup path
  BKUPDIR="/tmp/CAF"
  # Report file name
  RPTFILE=${BKUPDIR}/db2
  # HTMLFILE
  HTMLFILE=${RPTFILE}.html
  # SCORE
  SCORE=100
  #restore path
  RSTDIR="/var/SysCheck/Restore" 
  # PASS tag
  TAGPASS="【PASS】"
  # UNDO tag
  TAGUNDO="【UNDO】"
  # ALERT tag
  TAGALRT="【ALERT】"
  # TABLE tag
  TAGTABLE="【TABLE】"
  # set LANGUAGE
  export LANG="zh_CN.UTF-8"
  if [ ! -d ${BKUPDIR} ];then
  	mkdir -p ${BKUPDIR}
  fi  
  if [ ! -f ${RPTFILE} ];then
  	touch ${RPTFILE}
  fi  
  
  mkdir -p /tmp/dbcheck
  chmod 777 /tmp/dbcheck
}


shell_env_check() {
  
  if [ `whoami` != "root" ] ;  then
    echo "Please execute the script with root user! "
    exit 1
  else
	rm -rf /tmp/CAF/db2
	mv /tmp/CAF/db2new /tmp/CAF/db2new.`date +%Y%m%d`
  fi  
}


#
# print_msg()
# Description: Print message to screen and report file
# Input: 
#    $1: message to be printed
# Output: none
#

print_msg() {

  echo $* >> $RPTFILE
  
}

#
judge_db2_install(){
	/usr/local/bin/db2ls > /dev/null
	if [ $? = 0 ] ; then
		/usr/local/bin/db2ls | grep .0. | awk '{ print $2}' | while read version
		do
			print_msg "${TAGPASS}:当前环境安装的数据库版本包含${version}"
		done
	else
		print_msg "${TAGALRT}:DB2数据库未安装"
		exit 1
	fi	
}

#
# db2_version_check()
# Description: Check the db2 database version
# Input:  none
# Output:   none
#
db2_version_check(){
  DB2VERSION=`/usr/local/bin/db2ls | grep 0 | awk '{print $2}'`
  #exist_in_conf version "${DB2VERSION}" 
  if [ $? -eq 0 ];then
    print_msg "${TAGPASS}: 当前DB2数据库版本为${DB2VERSION}"
  else
    print_msg "${TAGALRT}: 当前DB2数据库版本过低，请联系数据库管理员进行补丁升级!"
  fi
}

#
# db2_license_check()
# Description: Check the db2 license
# Input:  none
# Output:   none
#
db2_license_check(){
	CURRENT_DATE=`date +%s`
	#DB2_INSTALL_PATH
  /usr/local/bin/db2ls | grep '0' | awk '{print $1}' | while read line
	do
	  LICENSE=`su - $1 -c "db2licm -l" | grep "Expiry date" | sed "s/\"//g" |  awk '{print $NF}'`
	  if [ "$LICENSE" == "registered" ] ; then
	    print_msg "${TAGALRT}: DB2数据库未注册，请联系数据库管理员进行版本注册!"
	  else
	    print_msg "${TAGPASS}: DB2数据库版本注册信息正确"
	  fi
  done 
  set +x
}


#
# db2set_var_check() DB2SET VARIABLE CHECK
# Description: Check variable for DB2SET
# Input:  
#    VARIABLE  : DB2SET VARIABLE
#    VALUE:  VALUES of DB2SET VARIABLE
# Output:   none
#
db2set_var_check(){
	INSTANCE=$3
  PRECHG=`su - $INSTANCE -c "db2set -all" | grep "$1"`
  PREVALUE=`echo ${PRECHG} | awk -F "=" '{print $NF}' | tr a-z A-Z`
  if [ "${PREVALUE}" == "$2" ] ; then
  		print_msg "${TAGPASS}:注册变量 $1 设置正确!"
		else
  		print_msg "${TAGALRT}应设置为$1=$2 "
  		case $OPTION in
    		c)  print_msg "${TAGALRT}: 注册变量 $1 设置错误，请联系数据库管理员进行正确的设置!"
      	;;
    		y)
	      INPUT=""
	      while [ "${INPUT}" != "y" -a "${INPUT}" != "n" ]
	      do
	        echo "修改注册变量 $1 为$2?[y/n] \c"
	        read INPUT < /dev/tty
	      done
	      if [ "${INPUT}" = "y" ];then
	        su - $INSTANCE -c "db2set $1=$2"
				  if [ $? -eq 0 ];then
			            print_msg "已修改注册变量 $1 为$2."
			            print_msg "${TAGUNDO}\"su - $INSTANCE -c db2set $1=${PREVALUE}\"."
				  else
				    print_msg "${TAGALRT}:\"su - $INSTANCE -c db2set $1=$2 执行出错：$@,请联系管理员检查"
				  fi
      	else
	        print_msg "${TAGALRT}: 注册变量 $1 设置错误."
	        print_msg "手动修改请使用\"su - $INSTANCE -c db2set $1=$2\"."
	      fi
	      ;;
    		f)
      		su - $INSTANCE -c "db2set $1=$2"
					if [ $? -eq 0 ];then
	        	print_msg "已修改注册变量 $1 为$2."
	        	print_msg "${TAGUNDO}\"su - $INSTANCE -c "db2set $1=$2"\"."
	      	else
	        	print_msg "${TAGALRT}:\"su - $INSTANCE -c db2set $1=$2 执行出错：$@,请联系管理员检查"
	      	fi
	      ;;
		    esac
		  fi
  }

#
# dbm_cfg_check() DB2 DATABASE MANAGER CONFIGURATION CHECK
# Description: Check Configuration for DB2 DATABASE MANAGER
# Input:  
#    CONFIGRATION  : Database Manager Configuration
#    VALUE:  Values of Database Manager Configuration 
# Output:   none
#
dbm_cfg_check(){
  INSTANCE=$3
  PRECHG=`su - $INSTANCE -c "db2 get dbm cfg" | grep "$1"`
	PREVALUE=`echo ${PRECHG} | awk  '{print $NF}'`
	if [ "${PREVALUE}" == "$2" ] ; then
  	print_msg "${TAGPASS}:数据库实例参数 $1 设置正确!"
	else
  	print_msg "${TAGALRT}当前设置:${PRECHG}，应为:$2 "
  	case $OPTION in
  		c)  print_msg "${TAGALRT}: 数据库实例参数 $1 设置错误，请联系数据库管理员进行正确的设置!"
    	;;
  		y)
	    INPUT=""
	    while [ "${INPUT}" != "y" -a "${INPUT}" != "n" ]
	    do
	      echo "修改数据库参数 $1 为$2?[y/n] \c"
	      read INPUT < /dev/tty
	    done
	    if [ "${INPUT}" = "y" ];then
	      su - $INSTANCE -c "db2 update dbm cfg using $1 $2"
			  if [ $? -eq 0 ];then
		            print_msg "已修改数据库实例参数 $1 为$2."
		            print_msg "${TAGUNDO}\"su - $INSTANCE -c db2 update dbm cfg using $1 ${PREVALUE}\"."
			  else
			    print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 update dbm cfg using $1 $2 执行出错：$@,请联系管理员检查"
			  fi
    	else
	      print_msg "${TAGALRT}: 数据库实例参数 $1 设置错误."
	      print_msg "手动修改请使用\"su - $INSTANCE -c db2 update dbm cfg for $DBNAME using $1 $2\"."
	    fi
	    ;;
  		f)
    		su - $INSTANCE -c "db2 update dbm cfg using $1 $2"
				if [ $? -eq 0 ];then
	      	print_msg "已修改数据库实例参数 $1 为$2."
	      	print_msg "${TAGUNDO}\"su - $INSTANCE -c "db2 update dbm cfg using $1 ${PREVALUE}"\"."
	    	else
	      	print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 update dbm cfg using $1 $2 执行出错：$@,请联系管理员检查"
	    	fi
	    ;;
	    esac
	  fi
}


#
# db_cfg_check() DB2 DATABASE CONFIGURATION CHECK
# Description: Check Configuration for DB2 DATABASE
# Input:  
#    CONFIGRATION  : Database Configuration
#    VALUE:  Values of Database Configuration 
# Output:   none
#
db_cfg_check(){
  INSTANCE=$3
  DBNAME=$4 
  PRECHG=`su - $INSTANCE -c "db2 get db cfg for $DBNAME" | grep "$1" | head -1`
  if [ "$PRECHG" != "" ] ; then
		PREVALUE=`echo ${PRECHG} | awk  '{print $NF}'`
		#AUTOVALUE=`echo $2 | grep AUTOMATIC`
		if [ "${PREVALUE}" == "$2" ] ; then
	  	print_msg "${TAGPASS}:数据库参数 $1 设置正确!"
		else
	  	print_msg "${TAGALRT}当前设置:${PRECHG}，应为:$2 "
	  	case $OPTION in
	  		c)  print_msg "${TAGALRT}: 数据库参数 $1 设置错误，请联系数据库管理员进行正确的设置!"
	    	;;
	  		y)
		    INPUT=""
		    while [ "${INPUT}" != "y" -a "${INPUT}" != "n" ]
		    do
		      echo "修改数据库参数 $1 为$2?[y/n] \c"
		      read INPUT < /dev/tty
		    done
		    if [ "${INPUT}" = "y" ];then
		      su - $INSTANCE -c "db2 update db cfg for $DBNAME using $1 $2"
				  if [ $? -eq 0 ];then
			            print_msg "已修改数据库参数 $1 为$2."
			            print_msg "${TAGUNDO}\"su - $INSTANCE -c db2 update db cfg for $DBNAME using $1 ${PREVALUE}\"."
				  else
				    print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 update db cfg for $DBNAME using $1 $2 执行出错：$@,请联系管理员检查"
				  fi
	    	else
		      print_msg "${TAGALRT}: 数据库参数 $1 设置错误."
		      print_msg "手动修改请使用\"su - $INSTANCE -c db2 update db cfg for $DBNAME using $1 $2\"."
		    fi
		    ;;
	  		f)
	    		su - $INSTANCE -c "db2 update db cfg for $DBNAME using $1 $2"
					if [ $? -eq 0 ];then
		      	print_msg "已修改数据库参数 $1 为$2."
		      	print_msg "${TAGUNDO}\"su - $INSTANCE -c "db2 update db cfg for $DBNAME using $1 ${PREVALUE}"\"."
		    	else
		      	print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 update db cfg for $DBNAME using $1 $2 执行出错：$@,请联系管理员检查"
		    	fi
		    ;;
		    esac
		fi
	fi
}

#
# db2_info_collect()
# Description: get db info
# Input:  $1 INSTANCE $2 DBNAME $3 TYPE $4 SQL
# Output:   none
#
db2_info_collect(){
	#set -x
	echo "update command options using o off;" > /tmp/dbcheck/$3.sql
	echo "connect to $2;" >> /tmp/dbcheck/$3.sql
	echo "update command options using x on o on;" >> /tmp/dbcheck/$3.sql
	echo "$4;" >> /tmp/dbcheck/$3.sql
	su - $1 -c "db2 -tf /tmp/dbcheck/$3.sql" > /tmp/dbcheck/$3.out
}


#
# bufferpool_check()
# Description: Check the db2 bufferpool size
# Input:  none
# Output:   none
#
# 主机内存 36%
bufferpool_check(){	
  db2_info_collect $1 $2 bufferpool "select bpname,PAGESIZE,NPAGES,PAGESIZE/1024*NPAGES/1024 from syscat.bufferpools"
  
  cat /tmp/dbcheck/bufferpool.out | grep SQL > /dev/null
	if [ $? -eq 0 ]; then 
		print_msg "${TAGALRT}命令执行失败！"
		exit 0
	fi
  
  cat /tmp/dbcheck/bufferpool.out | grep -v DB20000I | grep -v '^$' | while read LINE 
  do
  	BPNAME=`echo $LINE | awk '{print $1}'`
  	PAGESIZE=`echo $LINE | awk '{print $2}'`
  	OLDPAGE=`echo $LINE | awk '{print $3}'`
  	BPSIZE=`echo $LINE | awk '{print $4}'`
  	if [ $BPSIZE -ge 1000 ] ; then
    	print_msg "${TAGPASS}: BUFFERPOOL:${BPNAME}初始值为${BPSIZE}MB，设置正确!"
  	else
    	print_msg "${TAGALRT}: BUFFERPOOL:${BPNAME}初始值为${BPSIZE}MB，建议至少为1G！"
    	#NPAGES=$((1024*1024*1024/$PAGESIZE))
    	case $OPTION in
      		c)  print_msg "${TAGALRT}: BUFFERPOOL:${BPNAME}初始值为${BPSIZE}MB，请联系数据库管理员进行正确的设置!"
        	;;
      		y)
	        INPUT=""
	        while [ "${INPUT}" != "y" -a "${INPUT}" != "n" ]
	        do
	          echo "修改缓冲池${BPNAME}大小为 1G ?[y/n] \c"
	          read INPUT < /dev/tty
	        done
	        if [ "${INPUT}" = "y" ];then
	          su - $INSTANCE -c "db2 alter bufferpool $BPNAME size $NPAGES"
					  if [ $? -eq 0 ];then
				            print_msg "已修改缓冲池 $BPNAME 大小为1G."
				            print_msg "${TAGUNDO}\"su - $INSTANCE -c db2 alter bufferpool $BPNAME size ${OLDPAGE}\"."
					  else
					    print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 alter bufferpool $BPNAME size $NPAGES 执行出错：$@,请联系管理员检查"
					  fi
        	else
	          print_msg "${TAGALRT}: 修改缓冲池 $BPNAME 发生错误."
	          print_msg "手动修改请使用\"su - $INSTANCE -c db2 alter bufferpool $BPNAME size $NPAGES\"."
	        fi
	        ;;
      		f)
        		su - $INSTANCE -c "db2 alter bufferpool $BPNAME size $NPAGES"
						if [ $? -eq 0 ] ; then
	          	print_msg "已修改缓冲池 $BPNAME 大小为1G."
	          	print_msg "${TAGUNDO}\"su - $INSTANCE -c db2 alter bufferpool $BPNAME size ${OLDPAGE}\"."
	        	else
	          	print_msg "${TAGALRT}:\"su - $INSTANCE -c db2 alter bufferpool $BPNAME size ${NPAGES} 执行出错：$@,请联系管理员检查"
	        	fi
	        ;;
			    esac
  	fi
  done
}

#
# db2_storage_check()
# Description: print os version
# Input: none
# Output: none
#
db2_storage_check(){
	#log path
	FLAG=0
	INSTANCE=$1
  DBNAME=$2
  
  LOGPATH=`su - $INSTANCE -c "db2 get db cfg for $DBNAME" | grep "Path to log files" | awk '{print $NF}'`
	ARCHIVE_METH=`su - $INSTANCE -c "db2 get db cfg for $DBNAME" | grep "LOGARCHMETH1" | awk '{print $NF}'`	
	case $ARCHIVE_METH in
    OFF)  ARCH_LOG_PATH="OFF"
    ;;
    LOGRETAIN)  ARCH_LOG_PATH=$LOGPATH
    ;;    
    USEREXIT)  ARCH_LOG_PATH="OFF"
    ;;    
    *)  ARCH_LOG=`echo $ARCHIVE_METH | sed -e 's/DISK://g'`
    		ARCH_LOG_PATH=`df $ARCH_LOG |grep -v Filesystem |awk '{print $NF}'`
    ;;
  esac
  
  if [ "$LOGPATH" == "$ARCH_LOG_PATH" ] ; then
  		print_msg "${TAGALRT}活动日志与归档日志放置在同一文件系统上，请联系数据库管理员调整存储规划！"
  else
  		print_msg "${TAGALRT}活动日志与归档日志存储规划正确！"
  fi
	
	#view  LOGPATH on which disk & filesystem
	
	db2_info_collect $1 $2 dbpath "Select substr(TYPE,1,30),substr(PATH,1,100) from sysibmadm.DBPATHS"
  cat /tmp/dbcheck/dbpath.out | grep -v DB20000I | grep -v '^$' | while read TYPE DBPATH
  do
  	TPATH=`df $DBPATH  |grep -v Filesystem |awk '{print $NF}' `
  	if [ "$TYPE" != "$TYPE_TMP" ] && [ "$TPATH" == "$TPATH_TMP"  ] ; then
  		print_msg "${TAGALRT}存储规划异常${TYPE}与${TYPE_TMP}放置在同一文件系统上，请联系数据库管理员调整存储规划！"
  	fi
  	 	
    TYPE_TMP=`echo $TYPE`
    TPATH_TMP=`echo $TPATH`    
  done
		
	if [ $FLAG -eq 0 ] ; then
		print_msg "${TAGPASS}日志与数据放置在不同存储上，检查通过！" 
	fi
	
}


#
# db_status()
# Description: check db status
# Input: INSTANCE
#				 DBNAME
# Output: none
#
db_status(){
		INSTANCE=$1
    DBNAME=$2
		FLAG=0
		su - $INSTANCE -c db2 get db cfg for $DBNAME | grep pending | awk '{print $NF}' | while read DB_STATUS
		do
			if [ "$DB_STATUS" == "YES" ] ; then
				print_msg "${TAGALRT}数据库${DBNAME}状态异常，请联系数据库管理员检查！"
				FLAG=-1
			fi
		done
		
		if [ $FLAG -eq 0 ] ; then
				print_msg "${TAGPASS}数据库${DBNAME}状态正常！"
		fi
			
}

#
# db2_config_backup()
# Description: backup config version
# Input:  none
# Output:   none
#
#db2_config_backup(){
#	#save config
#	su - $INSTANCE -c db2set -all > db2set_${HOSTNAME}_${DATE}_${TIMEHMS}.out
#  su - $INSTANCE -c db2 get dbm cfg > dbm_cfg_${HOSTNAME}_${DATE}_${TIMEHMS}.out
#  su - $INSTANCE -c "db2 get db cfg for $DBNAME" > db_cfg_${HOSTNAME}_${DATE}_${TIMEHMS}.out
#  diff db2set_${HOSTNAME}_${DATE}_${TIMEHMS}.out 
#  
#  #check config
#  #参数版本备份
#}

#
# tbsp_check()
# Description: print table space info | check tablespace state & utilization
# Input: $1 = INSTANCE NAME
#				 $2 = DB NAME
# Output: none
#
tbsp_check(){
	db2_info_collect $1 $2 tbspace "select TBSP_ID,TBSP_NAME,TBSP_TYPE,int(TBSP_UTILIZATION_PERCENT),TBSP_STATE from SYSIBMADM.TBSP_UTILIZATION"
	cat /tmp/dbcheck/tbspace.out | grep -v DB20000I | sed -e '/^$/d' | while read line
  do
  	TBSP_NAME=`echo $line | awk '{print $2}'`
  	TBSP_TYPE=`echo $line | awk '{print $3}'`
  	TBSP_UTILIZATION_PERCENT=`echo $line | awk '{print $4}'`
  	TBSP_STATE=`echo $line | awk '{print $5}'`
  	if [ $TBSP_UTILIZATION_PERCENT -ge 80 ] && [ "$TBSP_TYPE" == "DMS" ] ; then
  		print_msg "${TAGALRT}${TAGTABLE}$TBSP_ID|$TBSP_NAME|$TBSP_TYPE|$TBSP_UTILIZATION_PERCENT"
  	else
  	  if [ $TBSP_STATE != "NORMAL" ] ; then
  	  	print_msg "${TAGALRT}${TAGTABLE}$TBSP_ID|$TBSP_NAME|$TBSP_TYPE|$TBSP_UTILIZATION_PERCENT"
  	  else 
  			print_msg "${TAGPASS}${TAGTABLE}$TBSP_ID|$TBSP_NAME|$TBSP_TYPE|$TBSP_UTILIZATION_PERCENT"
  		fi
  	fi
  done
}

#
# table_index_check()
# Description: print table info | check table runstats time & state & reorg info
# Input: $1 = INSTANCE NAME
#				 $2 = DB NAME
# Output: none
#
table_index_check(){
	INSTANCE=$1
	DBNAME=$2
	db2_info_collect $1 $2 table "select tabschema,tabname from syscat.tables where status <>  'N'"
	cat /tmp/dbcheck/table.out | grep -v DB20000I | sed -e '/^$/d'  | while read TABNAME
	do
		print_msg "${TAGALRT}表${TABNAME}状态异常，请联系数据库管理员！"
	done
	
	#check table whether need runstats
	db2_info_collect $1 $2 table_runstat "select tabschema||'.'||tabname from syscat.tables where tabschema not like 'SYS%' and stats_time < current timestamp - 30 days" 
	cat /tmp/dbcheck/table_runstat.out | grep -v DB20000I | sed -e '/^$/d' | while read TABNAME
	do
		print_msg "${TAGALRT}${TABNAME}表需要收集统计信息"
	done
	
	#check table & index whether need reorg
	su - $INSTANCE -c db2 reorgchk current statistics on table all > /tmp/reorgchk.txt
	sed 's/表：/Table: /' /tmp/reorgchk.txt | \
	awk '{
		if (NF == 2 && $1 ~ /^Table/) printf "\n\n"$2" "; 
		if (NF == 10 && $NF ~ /\*/) printf "table "$1"."$2" ";
		if (NF == 17 && $NF ~ /\*/) printf "index "$1"."$2" "
	}' | \
	awk '{
		if ($2 == "table") 
			print "db2 reorg table "$1"\ndb2 runstats on table "$1" with distribution and detailed indexes all allow write access";
		if ($2 == "index") 
			print "db2 reorg indexes all for table "$1"\ndb2 runstats on table "$1" with distribution and detailed indexes all allow write access"}' > /tmp/reorg_table.out
	
	 FLAG=0
	 cat /tmp/reorg_table.out | grep runstats | grep -v SYS | while read line
	 do
	 		TABLE=`echo $line | awk '{print $5}'`
	 		print_msg "${TAGALRT}${TABLE}表需要重组，请执行/tmp/reorg_table.out对表及索引进行重组！"
	 		FLAG=-1
	 done 
	
	if [ $FLAG -eq 0 ] ;  then
		print_msg "${TAGPASS}数据库中所有表不需要重组，检查通过！"
	fi
	
	#input info to temp_file
	#check index whether used
	su - $INSTANCE -c "db2pd -d $DBNAME -tcbstat index" > /tmp/dbcheck/tcbstat.out
	cat /tmp/dbcheck/tcbstat.out | \
	awk '{
		if (NF == 19 && $10 == 0 ) printf "table :"$2", indexid:"$3"\n"}' | grep -v :SYS > /tmp/dbcheck/index_used.out
	
	if [ -f /tmp/dbcheck/index_used.out ] ; then
	 cat /tmp/dbcheck/index_used.out | while read line
	 do
	 		INDEX=`echo $line | awk '{print $NF}'`
	 		print_msg "${TAGALRT}索引${INDEX}从未使用，建议删除该索引节省空间！"
	 done 
	else
		print_msg "${TAGALRT}db2pd执行失败，请联系数据库管理员检查原因！"
	fi	
}

#
# package_check()
# Description: check package
# Input: $1 = INSTANCE NAME
#				 $2 = DB NAME
# Output: none
#
package_check(){
	INSTANCE=$1
	DBNAME=$2
	FLAG=0
	db2_info_collect $1 $2 package "select pkgname from syscat.packages where VALID='N'"
	cat /tmp/dbcheck/package.out | grep -v DB20000I | sed -e '/^$/d' | while read PACKAGE
	do
		print_msg "${TAGALRT}${PACKAGE}状态异常，请进行重新绑定！"
		FLAG=-1
	done 
	
	if [ $FLAG -eq 0 ] ; then
		print_msg "${TAGPASS}数据库中全部package状态正常！"	
	fi
}
	

#
# backup_check()
# Description: check backup
# Input: $1 = INSTANCE NAME
#				 $2 = DB NAME
# Output: none
#
backup_check(){
	INSTANCE=$1
	DBNAME=$2
	FLAG=0
	
	for DIR in `ls -l /var/SysCheck| grep '^d' | grep -v Restore | tail -1 | awk '{print $NF}'`
  do
    if [ -d ${DIR} ];then
      LASTTIME=`echo $DIR | cut -d _ -f 1 ` 
    fi
  done
  
  db2_info_collect $1 $2 backup "select start_time,operation,operationtype from sysibmadm.db_history where operation='B' and start_time > '${LASTTIME}'" 
  
  BACK_TIME=`cat /tmp/dbcheck/backup.out | grep -v DB20000I | sed -e '/^$/d' | awk '{print $1}' `
  
  if  [ "$BACK_TIME" == "" ] ; then
			print_msg "${TAGALRT}近期没有执行数据库备份，请检查数据库备份情况！"
			FLAG=-1
	else
			cat /tmp/dbcheck/backup.out | grep -v DB20000I | sed -e '/^$/d' |  while read line
			do		
				STATE=`echo $line | awk '{print $3}'`
				if [ "$STATE" = "F" ] || [ "$STATE" = "" ] ; then
					print_msg "${TAGALRT}备份存在失败情况，请检查数据库备份情况！"		
					FLAG=-1
				fi
			done
	fi
	
	if [ $FLAG -eq 0 ] ; then
		print_msg "${TAGALRT}数据库备份正常，检查通过！"
	fi
}


#
# performance_info()
# Description: check performance_info
# Input: $1 = INSTANCE NAME
#				 $2 = DB NAME
# Output: none
#
performance_info(){
	INSTANCE=$1
	DBNAME=$2
	
	#time
	db2_info_collect $1 $2 time "SELECT DAY(SNAPSHOT_TIMESTAMP-DB_CONN_TIME)+1 FROM SYSIBMADM.SNAPDB"
	TIMEDIFF=`cat /tmp/dbcheck/time.out | grep -v DB20000I | sed -e '/^$/d' | awk '{print $1}'`
	
	#整体时间比例-----仪表盘 MON_DB_SUMMARY 
	db2_info_collect $1 $2 db "Select ELAPSED_EXEC_TIME_MS/1000,(LOCK_WAIT_TIME+POOL_READ_TIME+PREFETCH_WAIT_TIME+TOTAL_SORT_TIME)/1000,LOCK_WAIT_TIME/1000,TOTAL_SORT_TIME/1000,POOL_READ_TIME/1000,POOL_WRITE_TIME/1000,PREFETCH_WAIT_TIME/1000 FROM SYSIBMADM.SNAPDB"
	cat /tmp/dbcheck/db.out | grep -v DB20000I | sed -e '/^$/d' | while read line
	do
		TOTAL_ACT_TIME=`echo $line | awk '{print $1}'`
		MAIN_WAIT_TIME=`echo $line | awk '{print $2}'`
		LOCK_WAIT_TIME=`echo $line | awk '{print $3}'`
		TOTAL_SORT_TIME=`echo $line | awk '{print $4}'`
		POOL_READ_TIME=`echo $line | awk '{print $5}'`
		POOL_WRITE_TIME=`echo $line | awk '{print $6}'`
		PREFETCH_WAIT_TIME=`echo $line | awk '{print $7}'`
		
		print_msg "${TAGPASS}TOTAL_ACT_TIME :  $TOTAL_ACT_TIME "
		print_msg "${TAGPASS}MAIN_WAIT_TIME : $MAIN_WAIT_TIME"
		print_msg "${TAGPASS}LOCK_WAIT_TIME : $LOCK_WAIT_TIME"
		print_msg "${TAGPASS}TOTAL_SORT_TIME : $TOTAL_SORT_TIME"
		print_msg "${TAGPASS}POOL_READ_TIME : $POOL_READ_TIME"
		print_msg "${TAGPASS}POOL_WRITE_TIME : $POOL_WRITE_TIME"
		print_msg "${TAGPASS}PREFETCH_WAIT_TIME : $PREFETCH_WAIT_TIME"
	done 

	
	#sort
	db2_info_collect $1 $2 sort "SELECT SORT_HEAP_ALLOCATED,SORT_SHRHEAP_TOP, TOTAL_SORTS/(SORT_OVERFLOWS+1),TOTAL_SORT_TIME FROM SYSIBMADM.SNAPDB ORDER BY DBPARTITIONNUM" 
	cat /tmp/dbcheck/sort.out | grep -v DB20000I | sed -e '/^$/d' | while read line
	do
		SORTHEAP=`echo $line | awk '{print $1}'`
		SORT_TOP=`echo $line | awk '{print $2}'`
		OVERFLOW=`echo $line | awk '{print $3}'`
		TOTAL_SORT_TIME=`echo $line | awk '{print $4}' `
		
		if [ $OVERFLOW -gt 33 ] || [ $SORT_TOP -gt $SORTHEAP ] ; then
			print_msg "${TAGALRT}排序溢出率过大，增加排序堆或检查SQL语句"
		else
			print_msg "${TAGPASS}排序溢出率正常"
		fi
		
	done
	
	db2_info_collect $1 $2 lock "SELECT LOCK_WAIT_TIME,DEADLOCKS/${TIMEDIFF},LOCK_ESCALS/${TIMEDIFF},LOCK_WAITS/${TIMEDIFF},LOCK_TIMEOUTS/${TIMEDIFF} FROM SYSIBMADM.SNAPDB ORDER BY DBPARTITIONNUM"
	cat /tmp/dbcheck/lock.out | grep -v DB20000I | sed -e '/^$/d' | while read line
	do
		TOTAL_LOCK_TIME=`echo $line | awk '{print $1}'`
		DEADLOCKS=`echo $line | awk '{print $2}'`
		LOCK_ESCALS=`echo $line | awk '{print $3}'`
		LOCK_WAITS=`echo $line | awk '{print $4}'`
		LOCK_TIMEOUTS=`echo $line | awk '{print $5}'`
		#新增个数，死锁率每天低于3个，锁升级每天低于3个，锁超时每天低于5个，锁等待每天低于20个
		if [ $DEADLOCKS -gt 3 ] ; then
			print_msg "${TAGALRT}死锁出现次数过高！"	
		else
			print_msg "${TAGPASS}死锁出现次数正常！"
		fi
		
		if [ $LOCK_ESCALS -gt 3 ] ; then
			print_msg "${TAGALRT}锁升级出现次数过高！"	
		else
			print_msg "${TAGPASS}锁升级现次数正常！"
		fi
		
		if [ $LOCK_WAITS -gt 20 ] ; then
			print_msg "${TAGALRT}锁等待出现次数过高！"	
		else
			print_msg "${TAGPASS}锁等待出现次数正常！"
		fi
		
		if [ $LOCK_TIMEOUTS -gt 5 ] ; then
			print_msg "${TAGALRT}锁超时出现次数过高！"	
		else
			print_msg "${TAGPASS}锁超时出现次数正常！"
		fi
	done
	
	#缓冲池信息
	db2_info_collect $1 $2 buffer "SELECT SUBSTR(BP_NAME,1,20) AS BP_NAME,int(POOL_DATA_L_READS/(POOL_DATA_L_READS+POOL_DATA_P_READS+1)) as data_hitratio,int(POOL_INDEX_L_READS/(POOL_INDEX_P_READS+1)) as index_hitratio,POOL_ASYNC_DATA_WRITES/(POOL_DATA_WRITES+1) as DATA_WRITE_RATIO ,POOL_INDEX_WRITES/(POOL_INDEX_WRITES+1) as INDEX_WRITE_RATIO,POOL_NO_VICTIM_BUFFER FROM SYSIBMADM.SNAPBP where bp_name not like 'IBMSYSTEM%'" 
	cat /tmp/dbcheck/buffer.out | grep -i SQL1024N > /dev/null
	if [ $? -eq 0 ]; then 
		print_msg "${TAGALRT}数据库连接失败！"
	else
		cat /tmp/dbcheck/buffer.out | grep -v DB20000I | sed -e '/^$/d' | while read line
		do
			BP_NAME=`echo $line | awk '{print $1}'`
			DATA_HITRATIO=`echo $line | awk '{print $2}'` 
			INDEX_HITRATIO=`echo $line | awk '{print $3}'`
			POOL_NO_VICTIM_BUFFER=`echo $line | awk '{print $NF}'`
			if [ $DATA_HITRATIO -lt 80 ] || [ $INDEX_HITRATIO -lt 80 ] ; then
				print_msg "${TAGALRT}${BP_NAME}缓冲池命中率过低！"
			fi	
		done
	fi
	
	#日志信息
	db2_info_collect $1 $2 log "select INT(100 * (FLOAT(TOTAL_LOG_USED)/FLOAT(TOTAL_LOG_USED + TOTAL_LOG_AVAILABLE))), APPL_ID_OLDEST_XACT FROM SYSIBMADM.SNAPDB" 	
	cat /tmp/dbcheck/log.out | grep -v DB20000I | sed -e '/^$/d' | while read line
	do
		LOG_UTILIZATION_PERCENT=`echo $line | awk '{print $1}'`
		APPL_ID_OLDEST_XACT=`echo $line | awk '{print $2}'`
		if [ $LOG_UTILIZATION_PERCENT -ge 80 ] ; then
			print_msg "${TAGALRT}活动日志使用率异常，应用程序${APPL_ID_OLDEST_XACT} hold住日志，对其进行快照"
			su - $INSTANCE -c "db2 get snapshot for application agentid ${APPL_ID_OLDEST_XACT} > /tmp/snapshot.application.${APPL_ID_OLDEST_XACT}"
		else
			print_msg "${TAGPASS}活动日志使用率正常"
		fi
	done
	
	#语句信息
	print_msg "${TAGALRT}数据库中执行时间排前10的语句："
	#版本判断
	DB2INSTALL=`su - $INSTANCE -c "db2level" | grep installed | awk '{print $NF}' | sed 's/\".//g'`
  DB2VERSION=`/usr/local/bin/db2ls | grep $DB2INSTALL | awk '{print $2}'`
  DB2VERSION_1=`echo $DB2VERSION | cut -d . -f 1`
  DB2VERSION_2=`echo $DB2VERSION | cut -d . -f 2`
  
  if [ "$DB2VERSION_1" -le 9 ] && [ "$DB2VERSION_1" -lt 7 ] ; then
		db2_info_collect $1 $2 stmt "select AVERAGE_EXECUTION_TIME_S*NUM_EXECUTIONS,STMT_SORTS,substr(STMT_TEXT,1,50) as STMT_TEXT from sysibmadm.TOP_DYNAMIC_SQL order by AVERAGE_EXECUTION_TIME_S desc fetch first 10 rows only"
		cat /tmp/dbcheck/stmt.out | grep -v DB20000I | sed -e '/^$/d' >> $RPTFILE	  
  else 
		db2_info_collect $1 $2 stmt "select TOTAL_STMT_EXEC_TIME,TOTAL_CPU_TIME,TOTAL_IO_WAIT_TIME,ROWS_READ_PER_ROWS_RETURNED,EXECUTABLE_ID as STMT_TEXT from SYSIBMADM.MON_PKG_CACHE_SUMMARY order by TOTAL_STMT_EXEC_TIME desc fetch first 10 rows only"
		cat /tmp/dbcheck/stmt.out | grep -v DB20000I | sed -e '/^$/d' >> $RPTFILE	
	fi
}


#
# HA_check()
# Description: check powerHA & DB2 HADR
# Input: none
# Output: none
#
HA_check(){
   	#POWERHA
   	INSTANCE=$1
   	DBNAME=$2
   	UNAME=`uname`
   	if [ $UNAME == "AIX" ] ; then
	   	lslpp -L|grep cluster >/dev/null
			if [ $? -eq 0 ] ; then
				STATE=`lssrc -g cluster|sed '1d'`
				if [ "$STATE" = "" ] ; then
					print_msg "${TAGALRT}The HACMP is not config"
				else
					print_msg "${TAGPASS}The HACMP status is: ${STATE}"
				fi  
			else
				print_msg "${TAGALRT}This machine not install HACMP" 
			fi
		fi
   #HADR   
   su - $INSTANCE -c "db2pd -d $DBNAME -hadr" | grep "HADR is not active" > /dev/null
   if [ $? -eq 0 ] ; then
			print_msg "${TAGALRT}the machine not configration HADR "  
	 else
			su - $INSTANCE -c "db2pd -d $DBNAME -hadr" | grep "Peer"
			if [ $? -eq 0 ] ; then
				print_msg "${TAGPASS}HADR状态正常，主备机已同步"
			else
				print_msg "${TAGALRT}HADR状态正常，主备机未同步"
			fi 
	 fi
}


#
# diag_check()
# Description: check db2diag.log 
# Input: none
# Output: none
#
diag_check(){
	INSTANCE=$1
	FILE=`ls -l /var/SysCheck| grep '^d' | grep -v Restore | tail -1 | awk '{print $NF}'`
  if [ "$FILE" != "" ];then
      LASTTIME=`echo $FILE | cut -d _ -f 1` 
      YY=`echo $LASTTIME | cut -c 1-4`
      MM=`echo $LASTTIME | cut -c 5-6`
      DD=`echo $LASTTIME | cut -c 7-8`
  		ERRORCOUNT=`su - $INSTANCE -c "db2diag -g MESSAGE!:=2029060034 -t ${YY}-${MM}-${DD} -l Severe,Error | db2diag -g MESSAGE!:=2097151999 | db2diag -g FUNCTION!:=sqlt_logerr_data" | grep LEVEL | wc -l`
	 		print_msg "${TAGALRT}距上次检查新增 ${ERRORCOUNT} 处错误！"
  		su - $INSTANCE -c "db2diag -g MESSAGE!:=2029060034 -t ${YY}-${MM}-${DD} -l Severe,Error | db2diag -g MESSAGE!:=2097151999 | db2diag -g FUNCTION!:=sqlt_logerr_data" | tee -a $RPTFILE
  else
			su - $INSTANCE -c "db2diag -g MESSAGE!:=2029060034 -l Severe,Error | db2diag -g MESSAGE!:=2097151999 | db2diag -g FUNCTION!:=sqlt_logerr_data" | tee -a $RPTFILE
  fi   

  
  
}



db2_check(){
	judge_db2_install	
	#db2_version_check
	db2_license_check $1
	db2set_var_check DB2_EVALUNCOMMITTED ON $1 
	db2set_var_check DB2_SKIPINSERTED ON $1 
	db2set_var_check DB2COMM TCPIP $1 
	db2set_var_check DB2_PARALLEL_IO '*' $1 
	db2set_var_check DB2_COLLECT_TS_REC_INFO OFF $1 
	db2set_var_check DB2_OPTSTATS_LOG 'ON,NUM=10,SIZE=100' $1 
	db2set_var_check DB2_SKIPDELETED ON $1
	db2set_var_check DB2ASSUMEUPDATE ON $1
	dbm_cfg_check DFT_MON_BUFPOOL ON  $1 
	dbm_cfg_check DFT_MON_LOCK ON $1 
	dbm_cfg_check DFT_MON_SORT ON $1 
	dbm_cfg_check DFT_MON_TABLE ON $1 
	dbm_cfg_check DFT_MON_TIMESTAMP ON $1 
	dbm_cfg_check DFT_MON_UOW ON $1 
	dbm_cfg_check DFT_MON_STMT ON $1 
	dbm_cfg_check HEALTH_MON OFF $1 
	dbm_cfg_check INTRA_PARALLEL YES $1
	dbm_cfg_check MON_HEAP_SZ 'AUTOMATIC(1024)' $1
	dbm_cfg_check SHEAPTHRES 0 $1
	bufferpool_check $1 $2
	db_cfg_check 'code page' 1208 $1 $2
	db_cfg_check LOGFILSIZ 20480 $1 $2
	db_cfg_check LOGPRIMARY 40 $1 $2
	db_cfg_check LOGSECOND 20 $1 $2
	db_cfg_check LOGBUFSZ 10240 $1 $2
	db_cfg_check LOCKTIMEOUT 30 $1 $2
	db_cfg_check MAX_LOG 60 $1 $2
	db_cfg_check PCKCACHESZ 32768 $1 $2
	db_cfg_check REC_HIS_RETENTN 60 $1 $2
	db_cfg_check DBHEAP 'AUTOMATIC(25000)' $1 $2
	db_cfg_check LOCKLIST 10240 $1 $2
	db_cfg_check SHEAPTHRES_SHR 'AUTOMATIC(256000)' $1 $2
	db_cfg_check SORTHEAP 'AUTOMATIC(2560)' $1 $2
	db_cfg_check SELF_TUNING_MEM ON $1 $2
	db_cfg_check UTIL_HEAP_SZ 12500 $1 $2
	db_cfg_check BLK_LOG_DSK_FUL YES $1 $2
	db_cfg_check SOFTMAX 200 $1 $2
	db_cfg_check LOGRETAIN RECOVERY $1 $2
	db_cfg_check AUTO_MAINT OFF $1 $2
	db_cfg_check AUTO_DB_BACKUP OFF $1 $2
	db_cfg_check AUTO_TBL_MAINT OFF $1 $2
	db_cfg_check AUTO_RUNSTATS OFF $1 $2
	db_cfg_check AUTO_STMT_STATS OFF $1 $2
	db_cfg_check AUTO_STATS_PROF OFF $1 $2
	db_cfg_check AUTO_PROF_UPD OFF $1 $2
	db_cfg_check AUTO_REORG OFF $1 $2
	db_cfg_check CUR_COMMIT ON $1 $2
	db_cfg_check STMT_CONC LITERALS $1 $2
	db_cfg_check MON_UOW_DATA WITHOUT_HIST $1 $2
	db_cfg_check MON_LOCKTIMEOUT WITHOUT_HIST $1 $2
	db_cfg_check MON_LOCKWAIT WITHOUT_HIST $1 $2
	db_cfg_check MON_LW_THRESH 25000000 $1 $2
	db_cfg_check MON_LCK_MSG_LVL 3 $1 $2
	db2_storage_check $1 $2
	
	tbsp_check $1 $2
	table_index_check $1 $2
	package_check $1 $2
	backup_check $1 $2
	diag_check $1
								
	#print_msg "\n第四部分：数据库性能检查"
	performance_info $1 $2
	
	#print_msg "\n第五部分：数据库高可用检查"
	HA_check $1 $2
}


db2check_schedo(){
	i=1
	j=1
	SYSTEM=`uname` 
  if [ "$SYSTEM" == "Linux" ] ; then
		GREP_PARA="-A 3 -B 5"
  elif [ "$SYSTEM" == "AIX" ] ; then 
  	GREP_PARA="-p" 	
  fi  
	
	ps -ef | grep db2sysc | grep -v grep  > /dev/null
	if [ $? -eq 0 ] ; then
			#print_msg "\n第四部分：DB2数据库参数检查"
			ps -ef | grep db2sysc | grep -v grep | awk '{print $1}' | while read INSTANCE
	  	do 
	  		#print_msg "\n4.${i} =======================检查数据库实例${INSTANCE}==========================="
	  		su - $INSTANCE -c "db2 list db directory" | grep $GREP_PARA Indirect > /dev/null
	  		if [ $? -ne 0 ] ; then
	  			print_msg "${TAGALRT}:本地尚未创建数据库！"
	  			exit 1
	  		fi
	  		
	  		for DBNAME in `su - $INSTANCE -c "db2 list db directory" | grep $GREP_PARA Indirect | grep alias | awk '{print $4}'`
	  		do
	  			#print_msg "\n4.${i}.${j}: =======================检查数据库${DBNAME}==========================="
	  			su - $INSTANCE -c "db2 list active databases" | grep "Database name" | grep $DBNAME > /dev/null
	  			if [ $? = 0 ] ; then
	  				db2_check $INSTANCE $DBNAME
	  			else 
	  				print_msg "${TAGALRT}:DB2数据库${DBNAME}未激活"
	  			fi
	  			j=$((j+1))
	  		done
	  		i=$((i+1))
	  	done
	else
	    print_msg "${TAGALRT}:DB2数据库实例${INSTANCE}未启动"
	fi

}

shell_env_check
gbl_var_init
db2check_schedo
