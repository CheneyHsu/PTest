#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# For DB2 9.7/Mysql 5.6/Oracle 11g
# For WAS 7.0/Tomcat 8.x/Apache 2.x
##############################################################

#Lvm setup
function cswap()
{
mount -a|grep swap
if [ $? = 0 ];then
	clear
	echo "                                               "
	echo " 												 "
	echo " 												 "
	echo "       警告!已经存在swap分区!无需创建!!			 "
	echo " 												 "
	echo " 												 "
	echo " 												 "
	echo "                                               "
	exit
else
	echo ""
	echo ""
	echo -e "\033[;31m "现在开始创建swap分区?(Y/N) \033[0m"
	read LVYN
		echo "请输入swap大小(G)"
		read lvsize
		lvcreate -n lv_swap -L +$lvsize /dev/vg_system
		mkswap /dev/vg_system/lv_swap
		echo "/dev/vg_system/lv_swap    swap   swap  defaults   0 0" >> /etc/fstab
		swapon -a
fi
}

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
cswap
if [ $? = 0 ];
then
    finsh
else
   echo " "
   echo -e "\033[;31m 创建swap分区失败! \033[0m"
fi
