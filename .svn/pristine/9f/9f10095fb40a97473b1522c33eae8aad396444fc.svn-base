#!/bin/bash
#收集系统时区/etc/sysconfig/clock， 语言环境
#收集环境变量信息
#For Suse-linux
#开发日期 201305227 
#开发人员:LHL
#最后修改:20130606  有问题 linux 环境变量不带到子shell中

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


##收信语言环境
if [ -s ../conf/sysuser.conf ]
then
    cat ../conf/sysuser.conf |sort >../tmp/sysuser2.tmp
else
    cat sysuser.conf |sort >../tmp/sysuser2.tmp
fi

    cat /etc/passwd |grep -v "^#" |grep -v "*" |sort |awk -F: '{print $1}'>../tmp/sysuser1.tmp
    comm -23 ../tmp/sysuser1.tmp ../tmp/sysuser2.tmp  |while read i
    do
	  	   #取环境变量，取用户目录下的.profile文件中环境变量
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




