#!/usr/bin/env python
# -*- coding:utf-8 -*-
# 许成林
# 2014-10
# Version 1.0
#Check Linux system information and security
##############################################################
import os
import time
import sys
import commands
import readline
import rlcompleter
import atexit



def MAIN():
	try:
		# tab completion
		readline.parse_and_bind('tab: complete')
		# history file
		histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
		os.system('clear')
		print'''
#########################################################################################
		For linux system check (RHEL 6)
*    如果有任何问题，请联系我.
*    Cheney Hsu (KK)
*    Version 0.10
*    Mobile:	+86 18611846133
*    Mail:  xuchenglin@hrbb.com.cn

#########################################################################################
	'''
		print'''
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		请选择以下项（数字）:
	\033[;31m	1-> 系统基础信息. (hardware,memory,disk,lvm,etc...) \033[0m
	\033[;31m	2-> 上线参数检查. (Service,Kernel parameters,etc...) \033[0m
	\033[;31m	3-> 修复错误参数. \033[0m
	\033[;31m	4-> 查看结果. \033[0m
	\033[;31m	5-> 退出. \033[0m
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		'''

		key=raw_input("\033[;35m请输入您选择:\033[0m")
		if key == "2":
			Check()
			Results()
			Review("./checkresults.txt")
		elif key == "1":
			os.system("rm -rf ./baseinfo.txt")
			COMMAND()
			Review("./baseinfo.txt")
		elif key == "3":
			Fix()
			Review("./fixresults.txt")
		elif key == "4":
			os.system('clear')
			print '''
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            \033[;31m 1->查看系统基础配置信息 \033[0m
            \033[;31m 2->查看系统参数检测结果 \033[0m
            \033[;31m 3->查看系统修复检测结果 \033[0m
            \033[;31m 4->返回 \033[0m
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
			'''
            		print "      "
            		reviewkey=raw_input("\033[;35m 请输入您选择: \033[0m")
            		if reviewkey == "1":
                		Review("./baseinfo.txt")
            		elif reviewkey == "2":
                		Review("./checkresults.txt")
            		elif reviewkey == "3":
				Review("./fixresults.txt")
			elif reviewkey == "4":
                		MAIN()
			else:
				MAIN()
        	elif key == "5":
			quit();
		else :
			print "\033[;35m 请输入您选择:\033[0m"
			MAIN()
	except KeyboardInterrupt:
		print"exit "

commentlines = [
'HOSTNAME',
'System Information',
'All NIC Information',
'firmware-version',
'Processor Information',
'Network info',
'Router info',
'DNS',
'Fstab',
'Disk info',
'INODE',
'Mount',
'Fdisk',
'PV info',
'VG info',
'lv info',
'All system users',
'Login user',
'Uid 0 user',
'GID 0 group',
'Memory',
'Swap info',
'System service',
'Kernel info',
'OS System Issue',
'Uptime',
'Iptables info',
'kernel module info',
'PATH',
'Hosts file',
'Language',
'Run level',
'crontab',
'Ulimit',
'Ulimit File',
'IPCS',
'Sysctl.conf',
'Total RPM',
'Rpm List']

commandlines=[
'/bin/hostname',
'/usr/sbin/dmidecode -t \'1\'',
'lspci | grep Ethernet','x=`ifconfig -a | grep eth | wc -l`; y=0 ;if [ ${y} -lt ${x} ];then echo "NIC name is : eth$y";ethtool -i eth$y ; y=y+1; fi',
'lscpu',
'/sbin/ifconfig | grep  -E \'(Link | inet)\' ',
'/sbin/route -v',
'cat /etc/resolv.conf',
'cat /etc/fstab',
'/bin/df -hlP',
'/bin/df -ilP',
'/bin/mount | column -t',
'/sbin/fdisk -l',
'/sbin/pvdisplay',
'/sbin/vgdisplay',
'/sbin/lvdisplay',
'cat /etc/passwd',
'grep \'/bin/bash$\' /etc/passwd ',
'cat /etc/passwd |awk -F: \'{if ($3~/^0$/) print $1,$3}\'',
'cat /etc/group |awk -F: \'{if ($3~/^0$/) print $1,$3}\'',
'cat /proc/meminfo','/sbin/swapon -s',
'/sbin/chkconfig --list',
'uname -a',
'head /etc/issue',
'uptime',
'/sbin/iptables -L -n',
'/sbin/lsmod',
'env',
'cat /etc/hosts',
'cat /etc/sysconfig/i18n',
'/sbin/runlevel',
'if [ -d /var/spool/cron/tabs ];then for i in `ls /var/spool/cron/tabs/* | awk -F "/" \'{print $6}\'`; do         echo $i;         cat /var/spool/cron/tabs/$i | grep -v ^#;         echo \'\'; done; else for i in `ls /var/spool/cron/* | awk -F "/" \'{print $5}\'`; do         echo $i;         cat /var/spool/cron/$i;         echo \'\'; done; fi',
'ulimit -a',
'cat /etc/security/limits.conf',
'ipcs','cat /etc/sysctl.conf',
'rpm -qa > /tmp/rpm.txt;cat /tmp/rpm.txt | wc -l',
'cat /tmp/rpm.txt']

checkcommentlines=[
'Ssh version info sshd_config',
'Remote Version SSH issue.net',
'Terminal Time Out profile',
'Cups Service',
'Bluetooth Service',
'Ip6tables Service',
'Rhnsd Service',
'Saslauthd Service',
'Smartd Service',
'Ypbind Service',
'Ntpd Service',
'psacct Service',
'quota_nld Service',
'rdisc Service',
'Restorecond  Service',
'autofs Service',
'iptables Service',
'NFS Service',
'NFS LOCK Service',
'Cron Daemon',
'Selinux Disabled',
'UID 0 user',
'GID 0 user',
'Login System Users',
'Ntp Setup',
'ip_forwarding',
'Configure Mail Transfer Agent for Local-Only Mode',
'X-window',
'Command History',
'Mcelog']

fixcommandlines=[
'cp /etc/ssh/sshd_config ./back/ ; /bin/sed -i \'s/#Banner none/Banner \/etc\/issue.net/g\' /etc/ssh/sshd_config',
'cp /etc/issue.net ./back ; echo "Authorized uses only. All activity may be monitored and reported" > /etc/issue.net',
'cp /etc/profile ./back ;echo "TMOUT=180" >> /etc/profile',
'chkconfig  cups off',
'chkconfig  bluetooth off',
'chkconfig  ip6tables off ',
'chkconfig  rhnsd off',
'chkconfig  saslauthd off',
'chkconfig  smartd off',
'chkconfig  ypbind off',
'chkconfig  ntpd on',
'chkconfig  psacct off',
'chkconfig  quota_nld off',
'chkconfig  rdisc off',
'chkconfig  restorecond off',
'chkconfig  autofs off',
'chkconfig  iptables off',
'chkconfig  nfs off',
'chkconfig  nfslock off',
'chkconfig  crond on',
'grep \'SELINUX=enforcing\' /etc/selinux/config ; if [ $? = 0 ];then sed -i \'s/SELINUX=enforcing/SELINUX=disabled/g\' /etc/selinux/config;  else sed -i \'s/SELINUX=permissive/SELINUX=disabled/g\' /etc/selinux/config; fi',
'',
'',
'',
'',
'',
'',
'cp /etc/inittab ./back ;sed -i \'s/id:5:initdefault:/id:3:initdefault:/g\' /etc/inittab',
'echo \'export  HISTTIMEFORMAT=\"`whoami` : %F %T :\"\' >> /etc/profile',
'yum -y install mcelog'
]

fixcomment=[
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'`grep \'x:0:\' /etc/passwd`  请查看/etc/passwd来确认用户UID为0的数量.',
'`grep \'x:0:\' /etc/group`  请查看/etc/group来确认用户GID为0的用户数量.',
'`cat /etc/passwd  | awk -F \':\' \'{print $1,$4,$7}\' | grep \'/bin/bash$\' | grep -v root`  请查看 /etc/passwd 来确认登陆系统用户数量.',
'请重新设置您的NTP服务器，可以使用以下命令来设置 \"system-config-date\". 或者编辑 /etc/ntp.conf , 添加 server xxx.xxx.xxx.xxx 来设置ntp服务器IP. ',
'`grep \'net.ipv4.ip_forward\' /etc/sysctl.conf`\" 如果你需要使用路由转发,请忽略这个提示.否侧请你编辑/etc/sysctl.conf , 设置 \"net.ipv4.ip_forward = 0\"',
'如果您是邮件服务器,请忽略这个提示. 否则请编辑/etc/postfix/main.cf 设置 \"inet_interfaces = localhost\""',
'请关闭X-window,切换到文本模式运行.',
'历史指令查询添加时间和执行用户,编辑/etc/profile 添加: \'export  HISTTIMEFORMAT="`whoami` : %F %T :"\'',
'请创建yum软件仓库,执行如下指令: yum -y install mcelog'
]


checkcommandlines=[
'grep \'Banner /etc/issue.net\' /etc/ssh/sshd_config ; if [ $? = 0 ];then echo 1; else echo 0; fi',
'grep \'Kernel\' /etc/issue.net ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'grep \'TMOUT\' /etc/profile ; if [ $? = 0 ]; then echo 1 ; else echo 0;fi',
'chkconfig --list cups | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list bluetooth | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list ip6tables | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list rhnsd |grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list saslauthd | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list smartd | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list ypbind | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list ntpd | grep on ; if [ $? = 0 ]; then echo 1;else echo 0;fi',
'chkconfig --list psacct | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list quota_nld | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list rdisc | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list restorecond | grep \'5:on\' ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list autofs | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list iptables | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list nfs | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list nfslock | grep on ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'chkconfig --list crond | grep on ; if [ $? = 0 ]; then echo 1;else echo 0;fi',
'grep \'SELINUX=disabled\' /etc/selinux/config ;if [ $? = 0 ]; then echo 1;else echo 0;fi',
'uid0=`grep \'x:0:\' /etc/passwd | wc -l`;if [ $uid0 = 1 ];then echo 1 ;else echo 0;fi',
'gid0=`grep \'x:0:\' /etc/group | wc -c`;if [ $gid0 = 10 ];then echo 1 ;else echo 0;fi',
'loginsystem=`cat /etc/passwd  | awk -F \':\' \'{print $1,$4,$7}\' | grep \'/bin/bash$\'`;if [ $gid0atpasswd = 0 ];then echo 1 ;else echo 0 ;fi',
'ntpq -p | grep remote ; if [ $? = 0 ];then echo 1 ;else echo 0 ;fi',
'grep \'net.ipv4.ip_forward = 0\' /etc/sysctl.conf ; if [ $? = 0 ];then echo 1 ;else ehco 0;fi',
'netstat -an | grep 127.0.0.1:25;if [ $? = 0 ];then echo 1 ;else echo 0 ;fi',
'grep \'id:5:initdefault:\' /etc/inittab ;if [ $? = 0 ];then echo 0 ;else echo 1 ;fi ',
'grep \'HISTTIMEFORMAT\' /etc/profile ;if [ $? = 0 ];then echo 1 ;else echo 0 ;fi',
'rpm -qa | grep mcelog ; if [ $? = 0 ];then echo 1 ;else echo 0 ;fi ']

#求长度，为下面的程序执行定义
commentlines_num = len(commentlines)
checkcommandlines_num = len(checkcommandlines)

def COMMAND():
	x = 0
	while  x<commentlines_num:
		os.system("echo -e \033[31m '================ "+commentlines[x]+" ================'\033[0m >>"+'./baseinfo.txt')
		os.system(commandlines[x]+">>"+'./baseinfo.txt')
		x = x+1

def Check():
	os.system("rm -rf ./.results")
	x = 0
	while  x<checkcommandlines_num:
		os.system(checkcommandlines[x]+">>"+'./.results')
		x = x+1
def Results():
    os.system("mv ./checkresults.txt ./checkresults.txt.`date +%Y%m%d%H`")
    resultslines=[]
    r = file('./.results')
    for line in r.readlines():
        r_line = line.splitlines()
        resultslines.extend(r_line)
    x = 0
    while  x<checkcommandlines_num:
        os.system("echo '================"+checkcommentlines[x]+"================'>>"+'./checkresults.txt')
        if resultslines[x] == "0":
            os.system("echo -e \033[31m 'No Pass' \033[0m >>"+'./checkresults.txt')
        else :
            os.system("echo -e \033[32m 'Pass' \033[0m >>"+'./checkresults.txt')
        x=x+1

def Fix():
    os.system("rm -rf ./fixresults.txt")
    resultslines=[]
    r = file('./.results')
    for line in r.readlines():
        r_line = line.splitlines()
        resultslines.extend(r_line)
    x = 0
    while x < checkcommandlines_num:
        if resultslines[x] == "0":
            os.system(fixcommandlines[x])
        x = x + 1
    Check()
    r = file('./.results')
    for line in r.readlines():
        r_line = line.splitlines()
        resultslines.extend(r_line)
    y = 0
    while  y < checkcommandlines_num:
        os.system("echo '================ "+checkcommentlines[y]+" ================'>>"+'./fixresults.txt')
        if resultslines[y] == "0":
            os.system("echo -e \033[31m 'No Pass' \033[0m>>"+'./fixresults.txt')
            os.system("echo -e \033[36m "+fixcomment[y]+" \033[0m >>"+'./fixresults.txt')
        else :
            os.system("echo -e \033[32m 'Pass' \033[0m >>"+'./fixresults.txt')
        y = y+1

def Review(text):
	print "\033[;35m 您确定要查看这个检测结果？ (y/n) \033[0m"
	review = raw_input("\033[;35m 请输入您选择:\033[0m" )
	if review == "y":
		os.system("cat "+text+" |more")
        print "\033[;35m 是否返回主菜单？ (y/n) \033[0m"
        review2 = raw_input("\033[;35m 请输入您选择:\033[0m" )
        if review2 == "y":
            MAIN()
	else:
		MAIN()

if os.geteuid() != 0:
    print "This program must be run as root. Aborting."
    sys.exit(1)
else:
    MAIN()
