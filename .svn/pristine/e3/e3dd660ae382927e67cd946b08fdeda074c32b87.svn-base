#!/bin/sh
# 中国光大银行    
# 判断主备机脚本之设置环境
# Version v1.1
#2012-09-17 区分灾备模式
#2012-09-11
cd  /home/sysadmin/HostInfoCollection/bin

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

     echo  "   =|========================================|= "
     echo  "   =|                                        |= "
     echo  "   =|           主备机判断程序               |= "
     echo  "   =|                                        |= "
     echo  "   =|========================================|= "


echo
echo

HOSTIPFILE=../conf/HOSTIP.txt

SIP()
{
   while :
   do
   echo "请输入主机实IP地址"
   read HOSTIP
   if [ ${HOSTTYPE} = "AIX"  -o ${HOSTTYPE} = "HP-UX" ]
   then
	   netstat -in |grep -qw ${HOSTIP}
	   if [ $? -eq 0 ]
	   then
		   echo  "IP输入正确"
		   echo ${HOSTIP} >${HOSTIPFILE}
		   break
	    else
           echo  "IP输入错误"
           continue		   
       fi
    fi
     if [ ${HOSTTYPE} = "Linux" ]	
	 then
     	ifconfig -a |grep -qw ${HOSTIP}
		if [ $? -eq 0 ]
		then
		   echo  "IP输入正确"
		   echo ${HOSTIP} >${HOSTIPFILE}
		   break
		else
		    echo  "IP输入错误"
			continue
        fi	
     fi
	 done
}


if [ -f ${HOSTIPFILE} ]
then
    echo "已配置的实IP地址"
    cat ${HOSTIPFILE}
    echo "重新配置输入c,退出输入q,下一步输入n "
    read delip 
    if [ ${delip} = c -o ${delip} = C ]
    then
        rm ${HOSTIPFILE}
		SIP
    fi	
    if [ ${delip} = q -o ${delip} = Q ]
	then
	    exit
	fi	
else
   SIP
fi	


echo 
echo

#if [ -f ../conf/*_CEB.txt ]
ls ../conf/*CEB.txt >/dev/null 2>&1
if [ $? -eq 0 ]
then
    echo "已有配置文件存在"
	echo
    for x in `ls ../conf/*_CEB.txt`
    do
      echo $x
	  echo
      cat  $x
	  echo
      echo "删除配置文件输入c,下一步输入n "
      read  S
	  if [ $S = c -o $S = C ]
	  then
	      rm $x
		  echo "删除成功"	
	  fi	 
	  if [ ${S} = q -o ${S} = Q ]
	  then
	    exit
	  fi
    done	 

echo "开始配置输入n,退出输入q"
read jixu
if [ $jixu = q -o $jixu = Q ]
then
    exit
fi	
	
	
fi





while :
do

CHECKCONF=../tmp/checkconf.txt

#判断oralce是否在进行
ORACLE_PRO()
{
  echo "ORACLE          ora_smon"  >>${CHECKCONF}	
  # OraPro=`ps -ef |grep ora_smon |grep -v grep |wc -l`
    # if [ $OraPro -eq 0 ]
	# then
	  # echo "进程状态   未运行" >>chsu.log
	# else
	  # echo "进程状态     运行" >>chsu.log
	# fi
 }	

#判断应用进程是否在运行 
WEB_PRO()
 {
   echo " 请输入WEB服务运行的用户和进程，中间用空格分隔 "
   echo "例: weblogic   WebLogic.sh"
   read processname 
   echo "WEB   " ${processname} >>${CHECKCONF}	
 }  
 
 APP_PRO()
 {
   echo " 请输入APP服务运行的用户和进程中间用空格分隔 "
   echo "例: tuxedo    BBS"
   read processname 
   echo "APP   " ${processname} >>${CHECKCONF}	
 }  

#是不是有浮动Ip   
 FDIP()
 {

     echo  "============================================= "
	 echo  " 请输入应用浮动IP，无浮动ip不需要输入         "
	 echo  " 如有多个浮动IP需要输入多个                   "
     echo  "============================================= "
	 while :
	 do
	 echo  "请输入浮动ip地址或退出\q"
	 read aa
     if [  $aa = n  -o $aa = N -o $aa = q ]
	 then 
		break
     else
	     echo ${aa} |grep  -q "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"
		 if [ $? -eq 0 ]
		 then
		     echo "IP    " $aa  >>${CHECKCONF}
			 # netstat -in |grep -qw $aa
			 # if [ $? -eq 0 ]
			 # then
			     # echo  "IP           运行">>chsu.log
			 # else
			     # echo  "IP         未运行">>chsu.log
             # fi			 
		 else
		     echo "输入错误"
		 fi	 
     fi
     done 
 }   	
		

   
 cat /dev/null  >${CHECKCONF}

# 开始运行脚本
# 一 输入业务系统名称
echo "请输入业务系统简称"
read APPNAME
echo  "业务名称            "$APPNAME  >>${CHECKCONF}

#二   灾备模式
     echo 
	 echo  "                   灾备模式                     "
     echo  "   =|========================================|= "
     echo  "   =|                                        |= "
     echo  "   =|     1  |  2+2 failover                 |= "
	 echo  "   =|     2  |  2+1 failover                 |= " 
     echo  "   =|     3  |  1+1 failover                 |= "
     echo  "   =|     4  |  n+n 负载均衡                 |= "	 
     echo  "   =|     5  |  1+1 双活                     |= "		  
     echo  "   =|     6  |  单点                         |= "  
     echo  "   =|                                        |= "	
     echo  "   =|========================================|= "
	 echo  "选择相应数字" 
	 read NUM
	 #echo "灾备模式        "$NUM  >>${CHECKCONF}
     echo ${NUM} |grep -q [1-6]  
     if [ $? != 0 ]
     then 
         echo "灾备模式选择错误"
     	 echo "选择相应数字" 
     	read NUM
     fi
	 
	 case  $NUM  in 
		 1)
		   echo "灾备模式             2+2"  >>${CHECKCONF};;  
		 2)
		   echo "灾备模式             2+1"  >>${CHECKCONF};; 
		 3)
		   echo "灾备模式             1+1"  >>${CHECKCONF};; 
		 4)
		  echo "请输入灾备模式 例:3+1"
		   read zbmodel
		   echo "灾备模式            F${zbmodel}" >>${CHECKCONF};; 
		 5)
		   echo "灾备模式             B1+1" >>${CHECKCONF};; 	
		 6)
		   echo "灾备模式               1"  >>${CHECKCONF};; 		   

		 q|Q|e|exit)
		  exit;;
    esac
    

	
# 四   服务器角色-IP，进程
     echo 
	 echo  "                   应用角色                   "
     echo  "   =|========================================|= "
     echo  "   =|                                        |= "
     echo  "   =|     1  |  DB                           |= "
	 echo  "   =|     2  |  WEB                          |= " 
     echo  "   =|     3  |  APP                          |= "
     echo  "   =|     4  |  DB+WEB                       |= "	 
     echo  "   =|     5  |  DB+APP                       |= "		  
     echo  "   =|     6  |  WEB+APP                      |= " 
     echo  "   =|     7  |  DB+WEB+APP                   |= " 
     echo  "   =|     8  |  OTHER                        |= " 	 
     echo  "   =|                                        |= "	
     echo  "   =|========================================|= "
	 echo  "选择相应数字" 
	 read ROLE
#	 echo "服务器角色服务器用途        "$NUM  >>${CHECKCONF}
     echo ${ROLE} |grep -q [1-8]  
     if [ $? != 0 ]
     then 
         echo "选择错误"
     	echo "选择相应数字" 
     	read ROLE
     fi
	 case  $ROLE  in 
		 1)
		  echo "应用角色            DB"  >>${CHECKCONF}
		  ORACLE_PRO;;     		  
		 2)
		  echo "应用角色           WEB"  >>${CHECKCONF}
		  WEB_PRO;;
		 3)
		  echo "应用角色           APP"  >>${CHECKCONF}
		  APP_PRO;;	
         4)
		  echo "应用角色        DB+WEB"  >>${CHECKCONF}
		  ORACLE_PRO
		  WEB_PRO;;
         5)
		  echo "应用角色        DB+APP"  >>${CHECKCONF}
          ORACLE_PRO
          APP_PRO;;
         6)
		  echo "应用角色       WEB+APP"  >>${CHECKCONF}
          WEB_PRO
          APP_PRO;;
         7)
		  echo "应用角色    DB+WEB+APP"  >>${CHECKCONF}
          ORACLE_PRO
		  WEB_PRO
          APP_PRO;;
         8)
		  echo "应用角色         OTHER"  >>${CHECKCONF}
          APP_PRO;;		  
		 
		 q|Q|e|exit)
		  exit;;
    esac
		
# 三。 输入浮动IP

FDIP

echo "配置结果"
echo "------------------------------"	
cat ${CHECKCONF}
   
FILENAME=../conf/${APPNAME}_${NUM}_${ROLE}""_CEB.txt
echo 
echo "检查结果" 
echo "------------------------------"	  
sh hostcheck.sh
echo "保存配置文件输入y/Y,不保存输入n"
read  saveval
if [ ${saveval} = y -o ${saveval} = Y ]
then
  cp ${CHECKCONF}  ${FILENAME}
  if [ $? -eq 0 ]
  then
      echo "配置文件保存成功"
  fi    	  
fi

echo  "   =|========================================|= "
echo  "   =|     1  |  继续配置                     |= " 
echo  "   =|     2  |  配置完成退出                 |= "
echo  "   =|========================================|= "
echo "请输入"
read exitval
if [ $exitval = 1 ]
then
    continue
else
    break
fi	
	
done



	 
		
  
	 
	 
	 
	 