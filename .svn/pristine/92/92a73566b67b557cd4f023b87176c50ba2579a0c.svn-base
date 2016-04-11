#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# For DB2 9.7/Mysql 5.6/Oracle 11g
# For WAS 7.0/Tomcat 8.x/Apache 2.x
##############################################################
function ipandhost()
{
hostnum=`cat /etc/hosts | wc -l`
if [ "$hostnum" = "2" ]
then
	echo "设置/etc/hosts文件"
	hname=`hostname`
	if [ "$hname" = 'localhost' ];then
		echo "请输入新的主机名,不能使用默认的localhost.localdomain :>>"
		read hosts
		sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME="$hosts"/g"  /etc/sysconfig/network
		echo "请输入您的IP地址:"
		read sip
		echo "您输入的ip地址是: $sip , (Y/N)"
		read choose
		if [ $choose = 'Y' ] || [ $choose = 'y' ];then
			echo "$sip   $hosts" >> /etc/hosts
		else
			echo "添加/etc/hosts对应关系操作失败,请重试!"
		fi
	else
		echo "请输入您的IP地址:"
		read sip
		echo "您输入的ip地址是: $sip , (Y/N)"
		read choose
		if [ $choose = 'Y' ] || [ $choose = 'y' ];then
			echo "$sip   $hosts" >> /etc/hosts
		else
			echo "添加/etc/hosts对应关系操作失败,请重试!"
		fi
	fi
else
	:
fi
}

#Lvm setup
function lvsetup()
{
echo "Was的LV名称为was"
echo "Tomcat的LV名称为tomcat"
echo "Apache的LV名称为apache"
echo "DB2的LV名称为db2"
echo "Oracle的LV名称为oracle"
echo "Mysql的LV名称为mysql"

echo ""
echo ""
echo "是否需要创建固定LV(Y/N)"
read LVYN
if [ $LVYN = "Y" ] || [ $LVYN = "y" ];then
	echo "请输入您的lv名称(小写字母)"
	read lvname
	mount | grep lv_$lvname 
	if [ $? = 0 ];then
	:
	else
	echo "请输入LV大小(G)"
	read lvsize
	lvcreate -n lv_$lvname -L +$lvsize /dev/vg_system
	mkfs.ext4 /dev/vg_system/lv_$lvname
	mkdir /$lvname
	echo "/dev/vg_system/lv_$lvname    /$lvname   ext4  defaults   0 0" >> /etc/fstab
	mount -a
	chown $lvname.$lvname /$lvname
	echo "$lvname的卷组在 /$lvname"
	echo "所有组,所有者 已经更改为$lvname 账户所有"
	fi
else
:
fi
}

#yum仓库
function cdyum()
{
mkdir /mnt/cdrom
echo "请确认你的光盘在光驱: (Y/N)"
read cdyn
if [ $cdyn = 'Y' ]||[ $cdyn = 'y' ];
then
	mount /dev/sr0 /mnt/cdrom
	echo '
	[localcdrom]
	name=localcdrom
	baseurl=file:///mnt/cdrom
	gpgcheck=0' >> /etc/yum.repos.d/localcdrom.repo
	yum clean all
	yum update
	if [ $? = 0 ];
	then
		echo "软件仓库已经就绪"
	else
		echo "请将光盘放入光驱在执行"
		exit
	fi
else
	echo "Exit"
	exit
fi
}

#DB2
function DB2()
{
id db2inst1 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	chown dbinst1.db2iadm1 /db2
	echo "添加 db2inst1用户:301,db2iadm1组:301,密码:db2inst1"
	groupadd -g 301 db2iadm1
	useradd -u 301 -g db2iadm1 -d /db2/db2inst1 db2inst1
	echo "db2inst1" | passwd --stdin db2inst1
	finsh
fi
}


#Oracle
function Oracle()
{
id oracle 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	ipandhost
	cdyum
	yum clean all 
	yum update
	if [ $? = 0 ]
	then
		echo "安装必备软件包:"
		yum -y install compat-libcap1 compat-libstdc++* elfutils-libelf-devel gcc gcc-c++ glibc-devel* ksh libaio*.i686 libgcc*.i686 libstdc++* unixODBC*  cloog-ppl cpp glibc-headers kernel-headers libtool-ltdl.i686  mpfr ncurses-libs.i686 nss-softokn-freebl.i686 ppl readline.i686 libXp
	else
		echo "软件包安装失败,请检查yum仓库."
		exit
	fi
	lvsetup
	echo "添加 oracle组:305"
	echo "添加 dba组:306"
	echo "添加 oper组:307"
	echo "添加 oinstall组:308"
	
	groupadd -g 308 oinstall
	groupadd -g 306 dba
	groupadd -g 307 oper
	groupadd -g 305 oracle
	echo " "
	echo "添加 oracle用户:305,dba,oper,oinstall,oracle组:305/306/307/308,密码:oracle"
	useradd -u 305 -g oinstall -G dba,oper,oracle oracle
	echo "oracle" | passwd --stdin oracle
	
	echo "修改 /etc/sysctl.conf 文件参数为:"
	echo '
	fs.file-max = 6815744 
	fs.aio-max-nr=1048576  
	net.ipv4.ip_local_port_range = 9000 65500 
	net.core.rmem_default = 262144 
	net.core.rmem_max = 4194304 
	net.core.wmem_default = 262144 
	net.core.wmem_max = 1048576 
	kernel.sem = 250 32000 100 128'
	
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
	
	echo "  "
	echo "  "
	echo "修改limit限制参数:"
	echo '
	oracle           soft    nproc   2048
	oracle           hard    nproc   16384
	oracle           soft    nofile  2048
	oracle           hard    nofile  65536'
	
	echo '
	oracle           soft    nproc   2048
	oracle           hard    nproc   16384
	oracle           soft    nofile  2048
	oracle           hard    nofile  65536' >> /etc/security/limit.conf
	
	
	finsh
fi
}

#Mysql
function Mysql()
{
id oracle 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	echo "添加 mysql用户:304,tomcat组:304,密码:mysql"
	groupadd -g 304 mysql
	useradd -u 304 -g 304 mysql
	echo "mysql" | passwd --stdin mysql
	ipandhost
	lvsetup
	finsh
fi
}

#Finsh
function finsh()
{
echo "                                               "
echo " ######     #    #    #     #     ####   #    #"
echo " #          #    ##   #     #    #       #    #"
echo " #####      #    # #  #     #     ####   ######"
echo " #          #    #  # #     #         #  #    #"
echo " #          #    #   ##     #    #    #  #    #"
echo " #          #    #    #     #     ####   #    #"
echo "                                               "
}


#for Was 7.0
function WAS()
{
id was 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	ipandhost
	echo "添加 wan用户:401,was组:401,密码:was"
	groupadd -g 401 was 
	useradd -u 401 -g 401  was
	echo "was" | passwd --stdin was
	echo "添加 ulimit -n 8192 到/etc/profile"
	echo "ulimit -n 8192" >> /etc/profile
	lvsetup
	finsh
fi
}

#For Apache
function Apache()
{
id apache 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	ipandhost
	echo "添加 apache用户:402,apache组:402,密码:apache"
	groupadd -g 402 apache
	useradd -u 402 -g 402  apache
	echo "apache" | passwd --stdin apache
	lvsetup
	finsh
fi
}

#For Tomcat
function Tomcat()
{
id tomcat 
if [ $? = 0 ];
then
	echo "请不要多次设置相同系统环境"
else
	ipandhost
	echo "添加 tomcat用户:403,tomcat组:403,密码:tomcat"
	groupadd -g 403 tomcat
	useradd -u 403 -g 403  tomcat
	echo "tomcat" | passwd --stdin tomcat
	lvsetup
	finsh
fi
}


echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
		请选择以下项（数字）:
'	
echo -e	"\033[;31m	1-> DB2 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	2-> WAS 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	3-> Apache 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	4-> Tomcat 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	5-> Mysql 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	6-> Oracle 环境设置 \033[0m"
echo ' '
echo -e	"\033[;31m	7-> 退出 \033[0m"
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'
echo -e	"\033[;31m请输入您的选择： \033[0m"
read choose
case $choose in 
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
	7)
	   exit ;;
	*)
	   echo "请选择"1~7"选项"
esac
