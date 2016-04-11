#!/bin/bash
#�ռ�ϵͳʱ��/etc/sysconfig/clock�� ���Ի���
#�ռ�����������Ϣ
#For Suse-linux
#�������� 201305227 
#������Ա:LHL
#����޸�:20130606  ������ linux ����������������shell��

#.bash_profile  .bashrc  .profile


CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi


BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file

cat /etc/sysconfig/clock |awk -F"=" ' /^TIMEZONE/ {print "'"${HHNAME}|${CHECKDATE}"'||"$1"|"$2}'>${FILE_PATH}/${HHNAME}_${CHECKDATE}_sysenv.txt


##�������Ի���
if [ -s ../conf/sysuser.conf ]
then
    cat ../conf/sysuser.conf |sort >../tmp/sysuser2.tmp
else
    cat sysuser.conf |sort >../tmp/sysuser2.tmp
fi

    cat /etc/passwd |grep -v "^#" |grep -v "*" |sort |awk -F: '{print $1}'>../tmp/sysuser1.tmp
    comm -23 ../tmp/sysuser1.tmp ../tmp/sysuser2.tmp  |while read i
    do
	  	   #ȡ����������ȡ�û�Ŀ¼�µ�.profile�ļ��л�������
        ch_userdir=`cat /etc/passwd |grep "^${i}:" |awk -F: '{print $6}'` 
        if [ -s ${ch_userdir}/.profile ]
        then
           cat ${ch_userdir}/.profile >>${FILE_PATH}/${i}_profile.txt 
        fi  
        if [ -s ${ch_userdir}/.bash_profile ]
        then
            cat ${ch_userdir}/.bash_profile >>${FILE_PATH}/${i}_bash_profile.txt 
        fi 	
        if [ -s ${ch_userdir}/.bashrc ]
        then
            cat ${ch_userdir}/.bashrc >>${FILE_PATH}/${i}_bashrc.txt
        fi 	
#      su - $i -c locale |grep -e LANG -e "LC_" |awk -F"=" '{print "'"${HHNAME}|${CHECKDATE}|${i}"'|"$1"|"$2}'>>${FILE_PATH}/${HHNAME}_${CHECKDATE}_sysenv.txt
    done

#locale |awk -F"=" '{print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"$2}'>>${FILE_PATH}/${HHNAME}_${CHECKDATE}_sysenv.txt




