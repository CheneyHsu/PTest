#!/bin/sh
#判断服务器状态然后下载配置管理脚本
#编写时间:20121114
#编写人员:LHL
#更新日期:2012-12-25 加入TEST.conf标识文件判断,TEST.conf中为Y时下载，其它不下载。
#更新日期:2012-12-26 开发测试去掉重要系统，改变下载时间



#设置中文语言环境
HOSTTYPE=`uname -s`   #"AIX"  "HP-UX"  "Linux"
if [ ${HOSTTYPE} = "AIX" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi

if [ ${HOSTTYPE} = "HP-UX" ]
then
    export LC_ALL=zh_CN.hp15CN
    export LC_ALL=zh_CN.hp15CN
fi

if [ ${HOSTTYPE} = "Linux" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi

CHECKDATE=`date "+%Y-%m-%d"`
UPTIME=`date "+%d"`
BTIME=`date "+%H"`


cd /home/sysadmin/HostInfoCollection/bin
CONF=../conf
SYSTYPE=${CONF}/systype.conf
UPDATELOG=/home/sysadmin/HostInfoCollection/file/${CHECKDATE}_update.log

#册除下载标识文件
if [ -f /home/sysadmin/HostInfoCollection/bin/TEST.conf ]
then
  rm -f /home/sysadmin/HostInfoCollection/bin/TEST.conf 
  if [ $? -eq 0 ]
  then
    echo "删除TEST.conf 成功" >>$UPDATELOG
  fi	  
fi

#下载脚本
scriptdownload()
{
HOSTTYPE=`uname -s`   #"AIX"  "HP-UX"  "Linux"
if [ ${HOSTTYPE} = "AIX" ]
then
    SCRIPT_NAME=AIXHostInfo.tar
fi

if [ ${HOSTTYPE} = "HP-UX" ]
then
    SCRIPT_NAME=HPHostInfo.tar
fi

if [ ${HOSTTYPE} = "Linux" ]
then
    SCRIPT_NAME=LinuxHostInfo.tar
fi
if [ -d /home/sysadmin ]
  then
    echo "/home/sysadmin OK"
  else
  mkdir -p /home/sysadmin
fi
cd /home/sysadmin
rm -f ${SCRIPT_NAME}
ftp  -v -n 10.200.8.87 <<EOF
user  hostinfo hostinfo
cd /hostinfo/hostinfo/script
get ${SCRIPT_NAME}
bye
EOF
tar xf ${SCRIPT_NAME};
}


#判断标志文件
BSFILE()
{
ftp  -v -n 10.200.8.87 <<EOF
user  hostinfo hostinfo
cd /hostinfo/hostinfo/script
get $DOWNFILE
bye
EOF
if [ -f TEST.conf ];then
  BS=`cat $DOWNFILE`
else
  BS=N
fi
}



DOWNFILE="TEST.conf"

#跟据应用类型判断下载时间
if [ -f $SYSTYPE ];then
  SYSTYPEVL=`cat $SYSTYPE`
   case  $SYSTYPEVL  in 	   
		A|重要)	  
		   if [ $UPTIME = 28 ];then
			   BSFILE >>$UPDATELOG
			   if [ $BS = Y ];then
			   scriptdownload >>$UPDATELOG
			   fi
           fi 
		    ;;
		B)
		   if [ $UPTIME = 25 ];then
			   BSFILE >>$UPDATELOG
			   if [ $BS = Y ];then
			   scriptdownload >>$UPDATELOG
			   fi
           fi
		   ;;
		C)
		   if [ $UPTIME = 20 ];then
			   BSFILE >>$UPDATELOG
			   if [ $BS = Y ];then
			   scriptdownload >>$UPDATELOG
			   fi
           fi
          ;;		   
    esac
fi
	
echo "$UPTIME  $SYSTYPEVL $BS"	>>$UPDATELOG



