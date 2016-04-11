#!/bin/sh
#设置系统类型 开发测试机
#加主备机判断脚本
#最后修改2012-12-25 

LC_ALL=zh_CN.hp15CN
LANG=zh_CN.hp15CN
cd /home/sysadmin/HostInfoCollection/bin


CONF=../conf
SYSTYPE=${CONF}/systype.conf

HOSTTYPE()
{
#cat /dev/null >$SYSTYPE

     echo
	 echo  "                灾备等级                "
     echo  "   =|================================|= "
     echo  "   =|                                |= "
     echo  "   =|     a  |  A类系统              |= " 
     echo  "   =|     b  |  B类系统              |= "
     echo  "   =|     c  |  C类系统              |= "	
     echo  "   =|                                |= "	 
     echo  "   =|================================|= "
	 echo  "请选择" 
	 read NUM
	 echo ${NUM} |grep -q [A,B,C,Z,a,b,c,z]  
     if [ $? != 0 ]
     then 
         echo "系统类型选择错误"
     	 echo "请选择" 
     	 read NUM
     fi
		 case  $NUM  in   
		 a|A)
		   echo "A"  >${SYSTYPE};; 
		 b|B)
		   echo "B"  >${SYSTYPE};; 
		 c|C)
		   echo "C" >${SYSTYPE};;		   
		 q|Q|e|exit)
		  exit;;
    esac
}
	
	
if [ -f ${SYSTYPE} ];then
  a=`cat ${SYSTYPE}`
  echo "  ${a}类系统"
  echo "  配置正确yes/no回车"
  read nuvalue
  case ${nuvalue} in
     no|n|N)	 
       HOSTTYPE;;
    yes|y|Y)
      echo ;;
        *)
      HOSTTYPE;;
  esac
else
   HOSTTYPE
fi   
