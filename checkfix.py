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

#测试注册

def MAIN():
	os.system('mkdir /tmp/CAF > /dev/null 2>&1')
	try:
		# tab completion
		readline.parse_and_bind('tab: complete')
		# history file
		histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
		os.system('clear')
		print'''
#########################################################################################
		For linux system check (RHEL 6.4)
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
	
	\033[;31m	1-> Linux上线参数检查. (Service,Kernel parameters,etc...) \033[0m

	\033[;31m	2-> Linux修复. \033[0m

	\033[;31m	3-> DB2上线检查. \033[0m

	\033[;31m	4-> 查看结果. \033[0m

	\033[;31m	5-> 退出. \033[0m
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	

	'''

		key=raw_input("\033[;35m请输入您选择:\033[0m")
		if key == "1":
			Check()
			Results()
			os.system('clear')
			Review("/tmp/CAF/checkresults.txt")
		elif key == "2":
			Fix()
			os.system('clear')
			Review("/tmp/CAF/fixresults.txt")
		elif key == "3":
			os.system('bash ./DB2_Check.sh')
			os.system('iconv -f gbk -t utf-8 /tmp/CAF/db2  > /tmp/CAF/db2new;')
			os.system('clear')
			Review("/tmp/CAF/db2new")
		elif key == "4":
			os.system('clear')
			print '''
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		
		检测结果查询菜单            
	       
	    \033[;31m 1->查看系统参数检测结果 \033[0m
            
	    \033[;31m 2->查看系统修复检测结果 \033[0m
	    
	    \033[;31m 3->查看DB2检测结果 \033[0m
            
	    \033[;31m 4->返回 \033[0m

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


			'''
			print "           "
   	        	reviewkey=raw_input("\033[;35m 请输入您选择: \033[0m")
        	    	if reviewkey == "1":
            			Review("/tmp/CAF/checkresults.txt")
            		elif reviewkey == "2":
				Review("/tmp/CAF/fixresults.txt")
			elif reviewkey == "3":
				Review("/tmp/CAF/db2new")
			elif reviewkey == "4":
                		MAIN()
			else:
				MAIN()
        	elif key == "5":
			quit();
		else :
			print " "
			print "\033[;35m 请输入您选择:\033[0m"
			MAIN()
	except KeyboardInterrupt:
		print"exit "



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
'X-window',
'Command History',
'Mcelog'
]

fixcommandlines=[
'cp /etc/ssh/sshd_config /tmp/CAF/backup/ ; /bin/sed -i \'s/#Banner none/Banner \/etc\/issue.net/g\' /etc/ssh/sshd_config',
'cp /etc/issue.net /tmp/CAF/backup ; echo "Authorized uses only. All activity may be monitored and reported" > /etc/issue.net',
'cp /etc/profile /tmp/CAF/backup ;echo "TMOUT=180" >> /etc/profile',
'chkconfig  cups off',
'chkconfig  bluetooth off',
'chkconfig  ip6tables off ',
'chkconfig  rhnsd off',
'chkconfig  saslauthd off',
'chkconfig  smartd off',
'chkconfig  ypbind off',
'chkconfig  ntpd on;service ntpd start >/dev/null 2>&1',
'chkconfig  psacct off',
'chkconfig  quota_nld off',
'chkconfig  rdisc off',
'chkconfig  restorecond off',
'chkconfig  autofs off',
'chkconfig  iptables off',
'chkconfig  nfs off',
'chkconfig  nfslock off',
'chkconfig  crond on',
'grep \'SELINUX=enforcing\' /etc/selinux/config > /dev/null 2>&1 ; if [ $? = 0 ];then sed -i \'s/SELINUX=enforcing/SELINUX=disabled/g\' /etc/selinux/config;  else sed -i \'s/SELINUX=permissive/SELINUX=disabled/g\' /etc/selinux/config; fi',
'',
'',
'',
'echo "server  35.1.7.19 >> /etc/ntp.conf ; echo 35.1.7.20 >> /etc/ntp.conf ',
'',
'cp /etc/inittab /tmp/CAF/backup ;sed -i \'s/id:5:initdefault:/id:3:initdefault:/g\' /etc/inittab',
'echo \'export  HISTTIMEFORMAT=\"`whoami` : %F %T :\"\' >> /etc/profile',
'yum -y install mcelog >/dev/null 2>&1']


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
'`grep \'net.ipv4.ip_forward\' /etc/sysctl.conf`\" 如果你需要使用路由转发,请忽略这个提示. 否侧请你编辑/etc/sysctl.conf , 设置 \"net.ipv4.ip_forward = 0\"',
'请关闭X-window,切换到文本模式运行.',
'历史指令查询添加时间和执行用户,编辑/etc/profile 添加: \'export  HISTTIMEFORMAT=\"`whoami` : %F %T :"\'',
'请创建yum软件仓库,执行如下指令: yum -y install mcelog']


checkcommandlines=[
'LANG=C grep \'Banner /etc/issue.net\' /etc/ssh/sshd_config >/dev/null 2>&1; if [ $? = 0 ];then echo 1; else echo 0; fi',
'LANG=C grep \'Kernel\' /etc/issue.net > /dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C grep \'TMOUT\' /etc/profile >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 1 ; else echo 0;fi',
'LANG=C chkconfig --list cups | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list bluetooth | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list ip6tables | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list rhnsd |grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list saslauthd | grep on >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list smartd | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list ypbind | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list ntpd | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 1;else echo 0;fi',
'LANG=C chkconfig --list psacct | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list quota_nld | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list rdisc | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list restorecond | grep 5:on >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list autofs | grep on >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list iptables | grep on >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list nfs | grep on >/dev/null 2>&1 ; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list nfslock | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 0;else echo 1;fi',
'LANG=C chkconfig --list crond | grep on >/dev/null 2>&1; if [ $? = 0 ]; then echo 1;else echo 0;fi',
'LANG=C grep \'SELINUX=disabled\' /etc/selinux/config > /dev/null 2>&1;if [ $? = 0 ]; then echo 1;else echo 0;fi',
'LANG=C uid0=`grep \'x:0:\' /etc/passwd | wc -l`;if [ $uid0 = 1 ];then echo 1 ;else echo 0;fi',
'LANG=C gid0=`grep \'x:0:\' /etc/group | wc -c`;if [ $gid0 = 10 ];then echo 1 ;else echo 0;fi',
'LANG=C loginsystem=`cat /etc/passwd  | awk -F \':\' \'{print $1,$4,$7}\' | grep \'/bin/bash$\'|wc -l`;if [ $loginsystem = 1 ];then echo 1 ;else echo 0 ;fi',
'LANG=C ntpq -p 2> /dev/null | grep remote > /dev/null 2>&1; if [ $? = 0 ];then echo 1 ;else echo 0 ;fi',
'LANG=C grep \'net.ipv4.ip_forward = 0\' /etc/sysctl.conf >/dev/null 2>&1; if [ $? = 0 ];then echo 1 ;else ehco 0;fi',
'LANG=C grep \'id:5:initdefault:\' /etc/inittab >/dev/null 2>&1;if [ $? = 0 ];then echo 0 ;else echo 1 ;fi ',
'LANG=C grep \'HISTTIMEFORMAT\' /etc/profile > /dev/null 2>&1 ;if [ $? = 0 ];then echo 1 ;else echo 0 ;fi',
'LANG=C rpm -qa | grep mcelog >/dev/null 2>&1; if [ $? = 0 ];then echo 1 ;else echo 0 ;fi ']


title=['test','test2']

#求长度，为下面的程序执行定义
checkcommandlines_num = len(checkcommandlines)


def Check():
	os.system("rm -rf /tmp/CAF/.results")
	x = 0
	while  x<checkcommandlines_num:
		os.system(checkcommandlines[x]+">>"+'/tmp/CAF/.results')
		x = x+1
def Results():
    os.system("mv /tmp/CAF/checkresults.txt /tmp/CAF/checkresults.txt.`date +%Y%m%d%H` > /dev/null 2>&1")
    resultslines=[]
    r = file('/tmp/CAF/.results')
    for line in r.readlines():
        r_line = line.splitlines()
        resultslines.extend(r_line)
    x = 0
    while  x<checkcommandlines_num:
        os.system("echo '================"+checkcommentlines[x]+"================'>>"+'/tmp/CAF/checkresults.txt')
        if resultslines[x] == "0":
            os.system("echo -e \033[31m 'No Pass' \033[0m >>"+'/tmp/CAF/checkresults.txt')
        else :
            os.system("echo -e \033[32m 'Pass' \033[0m >>"+'/tmp/CAF/checkresults.txt')
        x=x+1
    r.close()
def Fix():
    os.system('mkdir /tmp/CAF/backup 2>/dev/null')
    os.system("rm -rf /tmp/CAF/fixresults.txt")
    resultslines=[]
    fixresultslines=[]
    r = file('/tmp/CAF/.results')
    for line in r.readlines():
        r_line = line.splitlines()
        resultslines.extend(r_line)
    x = 0
    while x < checkcommandlines_num:
        if resultslines[x] == "0":
            os.system(fixcommandlines[x])
        x = x + 1
    r.close()
    Check()
    r = file('/tmp/CAF/.results')
    for line in r.readlines():
        r_line = line.splitlines()
        fixresultslines.extend(r_line)
    y = 0
    while  y < checkcommandlines_num:
        os.system("echo '================ "+checkcommentlines[y]+" ================'>>"+'/tmp/CAF/fixresults.txt')
        if fixresultslines[y] == "0":
            os.system("echo -e \033[31m 'No Pass' \033[0m>>"+'/tmp/CAF/fixresults.txt')
            os.system("echo -e \033[36m "+fixcomment[y]+" \033[0m >>"+'/tmp/CAF/fixresults.txt')
        else :
            os.system("echo -e \033[32m 'Pass' \033[0m >>"+'/tmp/CAF/fixresults.txt')
        y = y+1
    r.close()
def Review(text):
	print '''


	      '''
	print 	"\033[;35m 查看检查结果 (y/n) \033[0m"
	print '''
	    
	      '''
	review = raw_input("\033[;35m 请输入您的选择:\033[0m" )
	if review == "y":
		os.system("cat "+text+" | more")
		print '''
			
			'''
		raw_input("\033[;35m Enter键返回主菜单:\033[0m")
	os.system('clear')
#        review2 = raw_input("\033[;35m Enter键返回主菜单:\033[0m" )
	MAIN()
if os.geteuid() != 0:
    print "This program must be run as root. Aborting."
    sys.exit(1)
else:
    MAIN()
