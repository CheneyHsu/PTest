#!/bin/sh
# �й��������    
# �ж��������ű�֮���û���
# Version v1.1
#2012-09-17 �����ֱ�ģʽ
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
     echo  "   =|           �������жϳ���               |= "
     echo  "   =|                                        |= "
     echo  "   =|========================================|= "


echo
echo

HOSTIPFILE=../conf/HOSTIP.txt

SIP()
{
   while :
   do
   echo "����������ʵIP��ַ"
   read HOSTIP
   if [ ${HOSTTYPE} = "AIX"  -o ${HOSTTYPE} = "HP-UX" ]
   then
	   netstat -in |grep -qw ${HOSTIP}
	   if [ $? -eq 0 ]
	   then
		   echo  "IP������ȷ"
		   echo ${HOSTIP} >${HOSTIPFILE}
		   break
	    else
           echo  "IP�������"
           continue		   
       fi
    fi
     if [ ${HOSTTYPE} = "Linux" ]	
	 then
     	ifconfig -a |grep -qw ${HOSTIP}
		if [ $? -eq 0 ]
		then
		   echo  "IP������ȷ"
		   echo ${HOSTIP} >${HOSTIPFILE}
		   break
		else
		    echo  "IP�������"
			continue
        fi	
     fi
	 done
}


if [ -f ${HOSTIPFILE} ]
then
    echo "�����õ�ʵIP��ַ"
    cat ${HOSTIPFILE}
    echo "������������c,�˳�����q,��һ������n "
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
    echo "���������ļ�����"
	echo
    for x in `ls ../conf/*_CEB.txt`
    do
      echo $x
	  echo
      cat  $x
	  echo
      echo "ɾ�������ļ�����c,��һ������n "
      read  S
	  if [ $S = c -o $S = C ]
	  then
	      rm $x
		  echo "ɾ���ɹ�"	
	  fi	 
	  if [ ${S} = q -o ${S} = Q ]
	  then
	    exit
	  fi
    done	 

echo "��ʼ��������n,�˳�����q"
read jixu
if [ $jixu = q -o $jixu = Q ]
then
    exit
fi	
	
	
fi





while :
do

CHECKCONF=../tmp/checkconf.txt

#�ж�oralce�Ƿ��ڽ���
ORACLE_PRO()
{
  echo "ORACLE          ora_smon"  >>${CHECKCONF}	
  # OraPro=`ps -ef |grep ora_smon |grep -v grep |wc -l`
    # if [ $OraPro -eq 0 ]
	# then
	  # echo "����״̬   δ����" >>chsu.log
	# else
	  # echo "����״̬     ����" >>chsu.log
	# fi
 }	

#�ж�Ӧ�ý����Ƿ������� 
WEB_PRO()
 {
   echo " ������WEB�������е��û��ͽ��̣��м��ÿո�ָ� "
   echo "��: weblogic   WebLogic.sh"
   read processname 
   echo "WEB   " ${processname} >>${CHECKCONF}	
 }  
 
 APP_PRO()
 {
   echo " ������APP�������е��û��ͽ����м��ÿո�ָ� "
   echo "��: tuxedo    BBS"
   read processname 
   echo "APP   " ${processname} >>${CHECKCONF}	
 }  

#�ǲ����и���Ip   
 FDIP()
 {

     echo  "============================================= "
	 echo  " ������Ӧ�ø���IP���޸���ip����Ҫ����         "
	 echo  " ���ж������IP��Ҫ������                   "
     echo  "============================================= "
	 while :
	 do
	 echo  "�����븡��ip��ַ���˳�\q"
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
			     # echo  "IP           ����">>chsu.log
			 # else
			     # echo  "IP         δ����">>chsu.log
             # fi			 
		 else
		     echo "�������"
		 fi	 
     fi
     done 
 }   	
		

   
 cat /dev/null  >${CHECKCONF}

# ��ʼ���нű�
# һ ����ҵ��ϵͳ����
echo "������ҵ��ϵͳ���"
read APPNAME
echo  "ҵ������            "$APPNAME  >>${CHECKCONF}

#��   �ֱ�ģʽ
     echo 
	 echo  "                   �ֱ�ģʽ                     "
     echo  "   =|========================================|= "
     echo  "   =|                                        |= "
     echo  "   =|     1  |  2+2 failover                 |= "
	 echo  "   =|     2  |  2+1 failover                 |= " 
     echo  "   =|     3  |  1+1 failover                 |= "
     echo  "   =|     4  |  n+n ���ؾ���                 |= "	 
     echo  "   =|     5  |  1+1 ˫��                     |= "		  
     echo  "   =|     6  |  ����                         |= "  
     echo  "   =|                                        |= "	
     echo  "   =|========================================|= "
	 echo  "ѡ����Ӧ����" 
	 read NUM
	 #echo "�ֱ�ģʽ        "$NUM  >>${CHECKCONF}
     echo ${NUM} |grep -q [1-6]  
     if [ $? != 0 ]
     then 
         echo "�ֱ�ģʽѡ�����"
     	 echo "ѡ����Ӧ����" 
     	read NUM
     fi
	 
	 case  $NUM  in 
		 1)
		   echo "�ֱ�ģʽ             2+2"  >>${CHECKCONF};;  
		 2)
		   echo "�ֱ�ģʽ             2+1"  >>${CHECKCONF};; 
		 3)
		   echo "�ֱ�ģʽ             1+1"  >>${CHECKCONF};; 
		 4)
		  echo "�������ֱ�ģʽ ��:3+1"
		   read zbmodel
		   echo "�ֱ�ģʽ            F${zbmodel}" >>${CHECKCONF};; 
		 5)
		   echo "�ֱ�ģʽ             B1+1" >>${CHECKCONF};; 	
		 6)
		   echo "�ֱ�ģʽ               1"  >>${CHECKCONF};; 		   

		 q|Q|e|exit)
		  exit;;
    esac
    

	
# ��   ��������ɫ-IP������
     echo 
	 echo  "                   Ӧ�ý�ɫ                   "
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
	 echo  "ѡ����Ӧ����" 
	 read ROLE
#	 echo "��������ɫ��������;        "$NUM  >>${CHECKCONF}
     echo ${ROLE} |grep -q [1-8]  
     if [ $? != 0 ]
     then 
         echo "ѡ�����"
     	echo "ѡ����Ӧ����" 
     	read ROLE
     fi
	 case  $ROLE  in 
		 1)
		  echo "Ӧ�ý�ɫ            DB"  >>${CHECKCONF}
		  ORACLE_PRO;;     		  
		 2)
		  echo "Ӧ�ý�ɫ           WEB"  >>${CHECKCONF}
		  WEB_PRO;;
		 3)
		  echo "Ӧ�ý�ɫ           APP"  >>${CHECKCONF}
		  APP_PRO;;	
         4)
		  echo "Ӧ�ý�ɫ        DB+WEB"  >>${CHECKCONF}
		  ORACLE_PRO
		  WEB_PRO;;
         5)
		  echo "Ӧ�ý�ɫ        DB+APP"  >>${CHECKCONF}
          ORACLE_PRO
          APP_PRO;;
         6)
		  echo "Ӧ�ý�ɫ       WEB+APP"  >>${CHECKCONF}
          WEB_PRO
          APP_PRO;;
         7)
		  echo "Ӧ�ý�ɫ    DB+WEB+APP"  >>${CHECKCONF}
          ORACLE_PRO
		  WEB_PRO
          APP_PRO;;
         8)
		  echo "Ӧ�ý�ɫ         OTHER"  >>${CHECKCONF}
          APP_PRO;;		  
		 
		 q|Q|e|exit)
		  exit;;
    esac
		
# ���� ���븡��IP

FDIP

echo "���ý��"
echo "------------------------------"	
cat ${CHECKCONF}
   
FILENAME=../conf/${APPNAME}_${NUM}_${ROLE}""_CEB.txt
echo 
echo "�����" 
echo "------------------------------"	  
sh hostcheck.sh
echo "���������ļ�����y/Y,����������n"
read  saveval
if [ ${saveval} = y -o ${saveval} = Y ]
then
  cp ${CHECKCONF}  ${FILENAME}
  if [ $? -eq 0 ]
  then
      echo "�����ļ�����ɹ�"
  fi    	  
fi

echo  "   =|========================================|= "
echo  "   =|     1  |  ��������                     |= " 
echo  "   =|     2  |  ��������˳�                 |= "
echo  "   =|========================================|= "
echo "������"
read exitval
if [ $exitval = 1 ]
then
    continue
else
    break
fi	
	
done



	 
		
  
	 
	 
	 
	 