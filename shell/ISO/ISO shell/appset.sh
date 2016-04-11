#!/bin/bash

# 许成林
# 2015-01
# Version 1.0
# For DB2 9.7/Mysql 5.6/Oracle 11g
# For WAS 7.0/Tomcat 8.x/Apache 2.x
##############################################################

source /sbin/setenv.sh

function app() {
    rm -rf /tmp/setup/app
    exec 3>&1
    VALUES=$(dialog --title "INDEX" --menu "请选择" 15 30 10  \
 1 "DB2 环境设置" 2 "WAS 环境设置" 3 "Apache 环境设置" 4 "Tomcat 环境设置" 5 "Mysql 环境设置" 6 "Oracle 环境设置" 7 "退出" 2>&1 1>&3)
    exec 3>&-
    echo $VALUES > /tmp/setup/app
}


#DB2
function DB2()
{
    id db2inst1
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "DB2 对应环境已经存在" 5 50
    else
        echo "添加 db2inst1用户:301,db2iadm1组:301,密码:db2inst1"
        groupadd -g 301 db2iadm1
        useradd -u 301 -g db2iadm1 -d /db2/db2inst1 db2inst1
        echo "db2inst1" | passwd --stdin db2inst1
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

#for Was 7.0
function WAS()
{
    id was
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "WAS 对应环境已经存在" 5 50
    else
        groupadd -g 401 was
        useradd -u 401 -g 401 was
        echo "was" | passwd --stdin was

        echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_keepalive_intvl = 5" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_fin_timeout = 20" >> /etc/sysctl.conf
        sysctl -p
        echo '
was             soft    core            unlimited
was             hard    core            unlimited
was             soft    data            -1
was             hard    data            -1
was             soft    file            -1
was             hard    file            -1
was             soft    stack           -1
was             hard    stack           -1
was             soft    cpu             -1
was             hard    cpu             -1
was             soft    nofile          8192
was             hard    nofile          8192
was             soft    nproc           10240
was             hard    nproc           10240' >> /etc/security/limits.conf
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

#For Apache
function Apache()
{
    id apache
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "Apache 对应环境已经存在" 5 50
    else
        ipandhost
        groupadd -g 402 apache
        useradd -u 402 -g 402 apache
        echo "apache" | passwd --stdin apache
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

#For Tomcat
function Tomcat()
{
    id tomcat
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "Tomcat 对应环境已经存在" 5 50
    else
        groupadd -g 403 tomcat
        useradd -u 403 -g 403 tomcat
        echo "tomcat" | passwd --stdin tomcat
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

#Mysql
function Mysql()
{
    id oracle
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "Mysql 对应环境已经存在" 5 50
    else
        groupadd -g 304 mysql
        useradd -u 304 -g 304 mysql
        echo "mysql" | passwd --stdin mysql
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

#Oracle
function Oracle()
{
    id oracle
    if [ $? = 0 ];
    then
        dialog --title "警告" --msgbox "Oracle 对应环境已经存在" 5 50
    else
        echo '
[localcdrom]
name=localcdrom
baseurl=file:///media/HRB\ Linux\ Install\ DVD/
gpgcheck=0' >> /etc/yum.repos.d/localcdrom.repo
        yum -y install compat-libcap1 compat-libstdc++* elfutils-libelf-devel gcc gcc-c++ glibc-devel* ksh libaio*.i686 libgcc*.i686 libstdc++* unixODBC* cloog-ppl cpp glibc-headers kernel-headers libtool-ltdl.i686 mpfr ncurses-libs.i686 nss-softokn-freebl.i686 ppl readline.i686 libXp
        groupadd -g 308 oinstall
        groupadd -g 306 dba
        groupadd -g 307 oper
        groupadd -g 305 oracle
        useradd -u 305 -g oinstall -G dba,oper,oracle oracle
        echo "oracle" | passwd --stdin oracle

        echo '
	fs.file-max = 6815744
	fs.aio-max-nr=1048576
	net.ipv4.ip_local_port_range = 9000 65500
	net.core.rmem_default = 262144
	net.core.rmem_max = 4194304
	net.core.wmem_default = 262144
	net.core.wmem_max = 1048576
	kernel.sem = 250 32000 100 128' >> /etc/sysctl.conf
        sysctl -p
        echo '
	oracle           soft    nproc   2048
	oracle           hard    nproc   16384
	oracle           soft    nofile  2048
	oracle           hard    nofile  65536' >> /etc/security/limits.conf
        dialog --title "完成" --msgbox "配置已经完成." 5 50
        index
    fi
}

app

case `cat /tmp/setup/app` in
    1)
        DB2 ;;
    2)
        WAS ;;
    3)
        Apache ;;
    4)
        Tomcat ;;
    5)
        Mysql ;;
    6)
        Oracle ;;
    *)
        index ;;
esac