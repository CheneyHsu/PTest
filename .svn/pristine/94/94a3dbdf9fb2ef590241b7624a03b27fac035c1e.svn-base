#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# For Setup System .
##############################################################
clear
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
		请选择以下项（数字）:
'	
echo -e	"\033[;31m	1-> LVM 扩展(仅支持vg_system) \033[0m"
echo ' '
echo -e	"\033[;31m	2-> 光盘仓库创建 \033[0m"
echo ' '
echo -e	"\033[;31m	3-> IP/网关/DNS 设置 \033[0m"
echo ' '
echo -e	"\033[;31m	4-> 软件安装 \033[0m"
echo ' '
echo -e	"\033[;31m	5-> VNC设置 \033[0m"
echo ' '
echo -e	"\033[;31m	6-> 退出设置 \033[0m"
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'

echo " "
echo -e "\033[;31m请输入您的选择: \033[0m"

function setupvnc(){
clear
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
		请选择以下项（数字）:
'	
echo -e "\033[;34m   1->  开启VNC  \033[0m"
echo ' '
echo -e "\033[;34m   2->  关闭VNC  \033[0m"
echo ' '
echo -e "\033[;34m   3->  退出设置  \033[0m"
echo ' '
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'
echo -e "\033[;34 请输入您的选择: \033[0m"
read chvnc
case $chvnc in
	1)
	    echo '
VNCSERVERS="1:root"
VNCSERVERARGS[2]="-geometry 1024x768 -nolisten tcp -localhost" ' > /etc/sysconfig/vncserver
		vncpasswd
		/etc/init.d/vncserver start
		;;
	2)
	    /etc/init.d/vncserver stop
	    ;;
	*)
	    exit ;;
esac
}


function installrpm(){
clear
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	'
echo ' '
echo -e "\033[;34m   输入要安装的软件名称  \033[0m"
echo ' '
echo -e "\033[;34m   Ctrl + C 退出  \033[0m"
echo ' '
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'
echo -e "\033[;35m 例如需要安装的软件包:  httpd-2.2.15-15.el6_2.1.x86_64.rpm  \033[0m"
echo -e "\033[;35m Yum 仓库安装输入： httpd  \033[0m"
echo " "
echo -e "\033[;35m SoftWare Nmae >>: \033[0m"
read irpm

yum clean all > /dev/null 2>&1 ; yum update > /dev/null 2>&1
yum list $irpm > /dev/null 2>&1
if [ $? = 0 ]
 then
 	yum -y install $irpm
 else
 	echo -e "\033[;34m <<<Faild!!   请检查仓库和输入的软件包名>>> \033[0m"
fi
}

function cdyum()
{
clear
mkdir /mnt/cdrom 2>/dev/null
echo "请确认你的光盘在光驱: (Y/N)"
read cdyn
if [ $cdyn = 'Y|y' ]||[ $cdyn = 'y' ] && [ ! -f /etc/yum.repos.d/localcdrom.repo ];
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
		echo -e "\033[;34m 软件仓库已经就绪 \033[0m"
	else
		echo "请将光盘放入光驱在执行"
		exit
	fi
else
	echo "请检查光盘,或者已经配置过yum仓库!"
	exit
fi
}


function netw()
{
clear
LANG=c ; system-config-network
}

#Lvm setup
function lvsetup()
{
clear
		echo "请输入需要扩展的lv名称"
		read lvname
		mount | grep $lvname
		if [ $? = 0 ];then
		echo "请输入LV大小(G)"
		read lvsize
		lvextent $lvname -L +$lvsize /dev/vg_system
			if [ $? = 0 ]
			then
				echo -e "\033[;34m 扩展成功. \033[0m"
			else
				echo -e "\033[;34m 可能空间不足,扩展失败.请手动查看 \033[0m"
			fi
		else
			echo -e "\033[;34m 您输入的lv名称不存在,扩展失败. \033[0m"
		fi
}

read chs
case "$chs" in
        1)
          ./setenvmod.sh;;
        2)
           cdyum;;
        3)
           netw;;
        4)
           installrpm;;
        5)
            setupvnc ;;
        *)
           exit ;;
esac
