#!/bin/bash
#�������ϵͳ�ճ����ϵͳ
echo "Version v2.0 2014-06-15"
#����oracle-dba���
#�����������������ļ�
#2012-01-06 �޸�24 crontab���ű�
#����35�ж�ip���������ǲ���255.255.255.0
#����36�ж��Զ����ݽ�����û������
#2012-09-29 �ı�����־����ʱ������
#v1.7��ͳһ�˺Ͱ汾�е���־����(03,10,16,17,18,22)
#v1.7��crontab �ƻ����������root�û��С�

#version:v1.6 
#2012--04-18���23_nbu_check ���NBU Media Server ��Drive ״̬
#2012-03-22 ���16 oracle��־����е�һ��bug����ѯ���������Ϣ��

#����з��������У��Ͳ��������µķ���
a=`ps -ef |grep "check/bin/Upload.sh" |grep "sh -c" |grep -v grep |wc -l`
if [ $a -gt 1 ]
then
   echo "running"
   exit;
fi



if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi

export LANG=C
export LC_ALL=C
export HHNAME


RAVEDIRECTORY=../file
UPDIRECTORY="/smdb/check/log"
UPERRORLOG=${UPDIRECTORY}/errorlog
LOGFILE=/home/sysadmin/check/file
ERRORLOG=/home/sysadmin/check/log/errorlog
UPUSER="smdb"
UPPASSWD="smdbput"
UPIP="10.200.8.87"
CHECKDATE=`date "+%Y-%m-%d"`


cd /home/sysadmin/check/bin
sh dailycheck.sh >$RAVEDIRECTORY/${HHNAME}_${CHECKDATE}.txt 2>&1
if [ $? -eq 0 ]
  then
    echo "Check  OK"
  else
    echo "Check  False"
fi

#20140618 ��oracle��־����
test -f /home/sysadmin/dba/clear_log/clear_log.sh &&  /home/sysadmin/dba/clear_log/clear_log.sh >>/home/sysadmin/check/file/check_out.txt  & 




#find /home/sysadmin/check/log/dflog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/errorlog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/swaplog -mtime +92 -type f -name *.log -exec rm -f {} \;
#find /home/sysadmin/check/log/tbslog -mtime +92 -type f -name *.log -exec rm -f {} \;
find /home/sysadmin/check/log -mtime +92 -type f -exec rm -f {} \;
find /home/sysadmin/check/file -mtime +92 -type f -name "*.txt" -exec rm -f {} \;
find /home/sysadmin/check/log/errorlog -type f -size 0 -exec rm -f {} \;


cd ${ERRORLOG}
ls |grep "^${CHECKDATE}" |while read i;
do
  mv ${i} ${HHNAME}_${i}
done

#oracle DBA 
cd /home/sysadmin/check/log/oracledba

if [ -f /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar ]
then
   rm -f /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar
fi

tar cf /home/sysadmin/check/log/oracledba/${HHNAME}_oracledba.tar  *.log && rm -f  /home/sysadmin/check/log/oracledba/*.log


cd ${LOGFILE}
ftp  -v -n $UPIP <<EOF
user  $UPUSER $UPPASSWD
prompt off
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}*.txt

cd ${UPDIRECTORY}/errorlog
lcd ${ERRORLOG}
mput ${HHNAME}_${CHECKDATE}*

cd ${UPDIRECTORY}/oracledba
lcd /home/sysadmin/check/log/oracledba
mput *oracledba.tar

bye
EOF
exit;
