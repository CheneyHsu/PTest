#!/bin/sh
#����ϵͳ���� �������Ի�
#���������жϽű�
#����޸�2012-12-25 

LC_ALL=zh_CN.hp15CN
LANG=zh_CN.hp15CN
cd /home/sysadmin/HostInfoCollection/bin


CONF=../conf
SYSTYPE=${CONF}/systype.conf

HOSTTYPE()
{
#cat /dev/null >$SYSTYPE

     echo
	 echo  "                �ֱ��ȼ�                "
     echo  "   =|================================|= "
     echo  "   =|                                |= "
     echo  "   =|     a  |  A��ϵͳ              |= " 
     echo  "   =|     b  |  B��ϵͳ              |= "
     echo  "   =|     c  |  C��ϵͳ              |= "	
     echo  "   =|                                |= "	 
     echo  "   =|================================|= "
	 echo  "��ѡ��" 
	 read NUM
	 echo ${NUM} |grep -q [A,B,C,Z,a,b,c,z]  
     if [ $? != 0 ]
     then 
         echo "ϵͳ����ѡ�����"
     	 echo "��ѡ��" 
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
  echo "  ${a}��ϵͳ"
  echo "  ������ȷyes/no�س�"
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
