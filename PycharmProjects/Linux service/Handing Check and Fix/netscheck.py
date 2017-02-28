#!/usr/bin/env python
# -*- coding:utf_8 -*-

import os
os.system('A=`date | awk -F : \'{print $3}\'|awk  -F " " \'{print $1}\'`;if [ "$A" != "0" ] ;then B=`expr 60 - $A` ; sleep $B ;fi')

def MAIN():
	HT()
    print("BASE SYSTEM CHECK")
    BASE()
    print("=======================================================")
    print("SYSTEM CHECK")
    SYS()
    print("=======================================================")
    print("SERVICE CHECK")
    SER()
    print("=======================================================")
    print("HARDENING OS CHECK")
    HARDENING()
    print("=======================================================")
	print("HARDENING SERVICE CHECK")
	HARDENINGSERVICES()
	print("=======================================================")
	print("HARDENING Net and Loging")
	HARDENINGNETWORKANDLOGING()
	print("=======================================================")
	print("File/Directory Permissions/Access")
	FDPA()

#HTML
def HT():
    FILENAME = FILE()
    os.system("echo '<HTML><HEAD><TITLE>'>>"+FILENAME)
    os.system("echo '</TITLE></HEAD><BODY><H1 align=center>Hardening Check</H1><PRE>'>>"+FILENAME)
    os.system("echo '<meta http-equiv='Content-Type' content='text/html' >'>>"+FILENAME)
    os.system("echo '<meta name='author' content='NONE'>'>>"+FILENAME)
    os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)


#BASE SYSTEM CHECK
def BASE():
     a_list = [ 'HOSTNAME',
		'OS Version',
		'Kernel Version' ]
     b_list = [ 'hostname',
		'lsb_release -a',
		'uname -a' ]
     FILENAME = FILE()
     x=0
     while  x<3 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME) 
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	
#SYSTEM CHECK
def SYS():
    a_list = ['Total RPM',
	      'Fstab',
	      'Fdisk Disk',
	      'Mount',
	      'PV',
	      'VG',
	      'LV',
	      'Memory',
	      'User',
	      'Group']
    b_list = ['rpm -qa > /tmp/OS_CHECK/rpm.txt ;sleep 3;cat /tmp/OS_CHECK/rpm.txt | wc -l',
	      'cat /etc/fstab',
	      'fdisk -l',
	      'mount',
	      'pvdisplay',
	      'vgdisplay',
          'lvdisplay',
	      'free -m',
	      'cat /etc/passwd',
	      'cat /etc/group']
    FILENAME = FILE()
    x=0
    while  x<10 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME) 
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
#SERVICE CHECK
def SER():
    a_list = ['ntp info','crontab','selinux info','iptables info','pstree','Check service ','rc.local']
    b_list = ['ntpq -p','crontab -l','getenforce','iptables -L -n', 'pstree','chkconfig --list','cat  /etc/rc.local']
    FILENAME = FILE()
    x=0
    while  x<7 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME) 
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)

#HARDENING CHECK
def HARDENING():
     a_list = [ 'Section 1.1.1 - 1.1.4 Partition of /tmp and options' ,
		'Section 1.1.5 Partition of /var and options',
		'Section 1.1.6 Bind Mount the /var/tmp directory to /tmp',
		'Section 1.1.7 Partition of /var/log and options',
		'Section 1.1.8 Partition of /var/log/audit and options',
		'Section 1.1.9 - 1.1.10 Partition of /home and options', 
		'Section 1.1.14 - 1.1.16 Partition of /dev/shm and options',
		'Section 1.1.17 Set Sticky Bit on All World-Writable Directories',
		'Section 1.2.2 Verify Red Hat GPG key is Installed' , 
		'Section 1.2.3 Verify that gpgcheck is Globally Activated',
		'Section 3.6 Configure Network Time Protocol',
		'Section 3.6 Check /etc/sysconfig/ntpd',
		'Section 3.16 Configure Mail Transfer Agent for Local-Only Mode' ,
		'Section 6.1.2 Enable Cron Daemon',
		'Section 6.2.12 Set Idle Timeout Interval for User Login',
		'Section 6.2.14 Set SSH Banner',
		'Section 6.3.1 Upgrade Password Hashing Algotithm SHA-512',
		'Section 6.3.6 Limit Password Reuse',
		'Section 8.1 Set Warning Banner for Standard Login Services /etc/motd',
		'Section 8.1 Set Warning Banner for Standard Login Services /etc/issue',
		'Section 8.1 Set Warning Banner for Standard Login Services /etc/issue.net',
		'Section 8.2 Remove OS Information from Login Warning Banners',
		'Section 8.2 /etc/motd Remove OS Information from Login Warning Banners',
		'Section 9.1.10 Find World Writable Files',
		'Section 9.1.11 Find Un-owned Files and Directories',
		'Section 9.1.12 Find Un-grouped Files and Directories',
		'Section 9.2.5 Verify No UID 0 Accounts Exist Other Than root',
		'Section 9.2.20 Check for Presence of User .netrc Files',
		'Section 9.2.21 Check for Presence of User .forward Files']

     b_list = [ 'mount | grep /tmp|grep nosuid | grep nodev|grep noexec ; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi', 
		'mount | grep /var | grep /dev; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi',
		'mount | grep "^/tmp"|grep /var/tmp | grep bind; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi',
		'mount | grep "/var/log" | grep dev; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi', 
		'mount | grep "/var/log/audit | grep dev |grep audit"; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi', 
		'mount | grep "/home"|grep nodev; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi',
		'mount | grep "/dev/shm"|grep nosuid | grep nodev|grep noexec ; if [ $? = 0 ];then echo "PASS"; else echo "NO PASS";fi', 
		'A=`df --local -P | awk {\'if(NR!=1)print $6\'}|xargs -I \'{}\' find \'{}\' -xdev -type d \( -perm -0002 -a ! -perm -1000 \)`;if [ "$A" = "" ];then  echo "PASS";else echo "$A";echo " ";echo "NO PASS";fi',
		'rpm -q --queryformat "%{SUNMARY}\n" gpg-pubkey > /dev/null;if [ "$?" = 0 ];then echo "PASS"; else echo "NO PASS";fi',
		'grep gpgcheck=1 /etc/yum.conf > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`grep -E "restrict default|restrict -6|^server" /etc/ntp.conf | wc -l `; if [ "$A" -gt "6" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "ntp:ntp" /etc/sysconfig/ntpd > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'netstat -an | grep "127.0.0.1:25 " > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'chkconfig --list crond| grep "3:on" > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "ClientAliveInterval" /etc/ssh/sshd_config | grep "300" > /dev/null && grep "ClientAliveCountMax"  /etc/ssh/sshd_config | grep "0"> /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^Banner" /etc/ssh/sshd_config | grep "/etc/issue.net" > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'authconfig --test|grep hashing|grep sha512 > /dev/null ;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "remember" /etc/pam.d/system-auth > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/motd|awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then A="";echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/issue|awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then A="";echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/issue.net|awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then A="";echo "PASS";else echo "NO PASS";fi',
		'egrep "(\\v|\\r|\\m|\\s)" /etc/issue > /dev/null && egrep "(\\v|\\r|\\m|\\s)" /etc/issue.net > /dev/null;if [ "$?" = 0 ];then echo "PASS"; else echo "NO PASS";fi',
		'egrep "(\\v|\\r|\\m|\\s)" /etc/motd > /dev/null ; if [ "$?" = 1 ];then echo "PASS"; else echo "NO PASS";fi',
		'A=`df --local -P | awk {\'if(NR!=1)print $6\'}|xargs -I \'{}\' find \'{}\' -xdev -type f  -perm -0002 -print`; if [ "$A" = "" ];then echo "PASS";else echo "NO PASS"; echo "" ;echo "$A";fi',
		'A=`df --local -P | awk {\'if(NR!=1)print $6\'}|xargs -I \'{}\' find \'{}\' -xdev -nouser -ls`; if [ "$A" = "" ];then  echo "PASS";else echo "$A";echo " ";echo "NO PASS";fi',
		'A=`df --local -P | awk {\'if(NR!=1)print $6\'}|xargs -I \'{}\' find \'{}\' -xdev -nogroup -ls`;if [ "$A" = "" ];then  echo "PASS";else echo "$A";echo " ";echo "NO PASS";fi',
		'A=`cat /etc/passwd | awk -F : \'($3 == 0){print $1}\'`;if [ "$A" = "root" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`find / -name .netrc`; if [ "$A" = "" ];then  echo "PASS";else echo "$A";echo " ";echo "NO PASS";fi',
		'A=`find / -name .forward`;if [ "$A" = "" ];then  echo "PASS";else echo "$A";echo " ";echo "NO PASS";fi']

     FILENAME = FILE()
     x=0
     os.system("echo 'Hardening Check For Nets'>>"+FILENAME)
     while  x<29 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME)
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)


def HARDENINGSERVICES():
     a_list = [ 'Section 2.1.1 Remeove telnet-server',
		'Section 2.1.3 Remove rsh-server' , 
		'Section 2.1.4 Remove rsh',
		'Section 2.1.6 Remove NIS Server',
		'Section 2.1.7 Remove tftp',
		'Section 2.1.8 Remove tftp-server',
		'Section 2.1.9 Remove talk',
		'Section 2.1.10 Remove talk-server',
		'Section 3.2 Remove X Windows',
		'Section 3.1 Set Daemon umask',
		'Section 3.5 Remove DHCP Server,',
		'Section 2.1.12 Disable chargen-dgram',
		'Section 2.1.13 disable chargen-stream',
		'Section 2.1.14 Disable daytime-dgran',
		'Section 2.1.15 Disable daytime-stream',
		'Section 2.1.16 Disable echo-dgram',
		'Section 2.1.17 Disable echo-stream',
		'Section 2.1.18 Disable tcpmux-server',
		'Section 3.3 Disable Avahi Server' ]
     b_list = [ 'rpm -ql telnet-server > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql rsh-server  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql rsh  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql ypserv  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql tftp  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql tftp-server  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql talk  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql talk-server  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'grep "^id:3:" /etc/inittab;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "umask" /etc/sysconfig/init | grep "027" > /dev/null ;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'rpm -ql dhcp  > /dev/null;if [ "$?" != "0" ];then echo "PASS";else echo "NO PASS";fi',
		'chkconfig chargen-dgram off;echo "PASS"',
		'chkconfig chargen-stream off;echo "PASS"',
		'chkconfig daytime-stream off;echo "PASS"',
		'chkconfig daytime-stream off;echo "PASS"',
		'chkconfig echo-dgram off;echo "PASS"',
		'chkconfig echo-stream off;echo "PASS"',
		'chkconfig tcpmux-server off;echo "PASS" ',
		'chkconfig avahi-daemon off;echo "PASS"']

     FILENAME = FILE()
     x=0
     while  x<19 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME)
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)


#Hardening Network Configurations and loging
def HARDENINGNETWORKANDLOGING():
     a_list = [ 'Section 4.1.1 Disable IP Forwarding',
		'Section 4.1.2 Disable Send Packet Redirects',
		'Section 4.2.1 Disable Source Routed Packet Acceptance',
		'Section 4.2.2 Disable ICMP Redirect Acceptance',
		'Section 4.2.3 Disable Secure ICMP redirect Acceptance',
		'Section 4.2.4 Log Suspicious Packets',
		'Section 4.2.5 Enable lgnore Broadcast Requests',
		'Section 4.2.6 Enable Bad Error Message Protection',
		'Section 4.2.7 Enable RFS-recommended Source Route Validation',
		'Section 4.2.8 Enable TCP SYN Cookies',
		'Section 4.5.3 Verify Permissions on /etc/hosts.allow',
		'Section 4.5.5 Verify Permissions on /etc/hosts.deny',
		'Section 4.7 Enable IPtables',
		'Section 6.2.1 Set SSH protocol to 2  or 3',
		'Section 6.2.4 Disable SSH X11 Forwarding',
		'Section 6.2.5 - 6.2.7 Set SSH MAXauth tries to 3 and IgnoreRhosts to Yes and HostbasedAuthentication to No',
		'Section 6.2.8 Disable SSH Root Login',
		'Section 6.2.9 Set SSH PermitEmptyPasswords to No',
		'Section 6.2.10 Do not Allow Users to Set Environment Options',
		#'Use Only Approved Cipher in Counter Mode',
		'Section 5.1.1 Install the rsyslog packages',
		'Section 5.1.2 Activate the rsyslog Service',
		'Section 5.1.5 Configure rsyslog to Send Logs to TLC',
		'Section 5.1.6 Configure hosts file to contain tlc IP address',
		'Section 6.2.2 Set LogLevel to INFO']
     b_list = [ 'A=`sysctl net.ipv4.ip_forward`;if [ "$A" = "net.ipv4.ip_forward = 0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{default,all}.send_redirects|grep 0 | wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{all,default}.accept_source_route|grep 0|wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{all,default}.accept_redirects|grep 0 |wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{all,default}.secure_redirects|grep 0 |wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{all,default}.log_martians|grep 1 |wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.icmp_echo_ignore_broadcasts|grep 1 |wc -l`;if [ "$A" = 1 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.icmp_ignore_bogus_error_responses|grep 1 |wc -l`;if [ "$A" = 1 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.conf.{all,default}.rp_filter|grep 1 |wc -l`;if [ "$A" = 2 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`sysctl net.ipv4.tcp_syncookies|grep 1 |wc -l`;if [ "$A" = 1 ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/hosts.allow |awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/hosts.deny |awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then echo "PASS";else echo "NO PASS";fi',
		'chkconfig --list iptables | grep 3:on > /dev/null;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep -E \'^Protocol 2|^Protocol 3\'  /etc/ssh/sshd_config > /dev/null ;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^X11Forwarding" /etc/ssh/sshd_config | grep "no" >/dev/null;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^MaxAuthTries" /etc/ssh/sshd_config|grep "3" >/dev/null&& grep "^IgnoreRhosts" /etc/ssh/sshd_config | grep "yes"> /dev/null && grep "^HostbasedAuthentication" /etc/ssh/sshd_config | grep "no"> /dev/null ;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^PermitRootLogin" /etc/ssh/sshd_config| grep "no" >/dev/null ;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^PermitEmptyPasswords" /etc/ssh/sshd_config |grep "no" >/dev/null ;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^PermitUserEnvironment" /etc/ssh/sshd_config|grep "no" > /dev/null;if [ "$?" = 0 ];then echo "PASS";else echo "NO PASS";fi',
		#'grep -v "Ciphers" /etc/ssh/sshd_config',
		'rpm -ql rsyslog > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'chkconfig --list rsyslog  | grep "3:on" > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "^authpriv" /etc/rsyslog.conf | grep @tlc;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`cat /etc/hosts;echo " ";echo  -e "Please Manual Check"`;echo "$A"',
		'grep "^LogLevel" /etc/ssh/sshd_config;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi']


     FILENAME = FILE()
     x=0
     while  x<24 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME)
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)


#File/Directory Permissions/Access
def FDPA():
     a_list = [ 'Section 1.5.1 Set User/Group Owner on /etc/grub.conf',
		'Section 6.1.4 - 6.1.9 Set User/Group Owner and permission on  /etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d',
		'Section 1.5.2 Set Permissions on /etc/grub.conf',
		'Section 6.2.3 Set permissions on /etc/ssh/sshd_config',
		'Section 9.1.2 , 9.1.6 Verify Permissions and Ownership on /etc/passwd ',
		'Section 9.1.5 , 9.1.9 Verify Permissions and Ownership on /etc/group',
		'Section 9.1.3 , 9.1.7 Verify Permissions and Ownership on /etc/shadow', 
		'Section 9.1.4 , 9.1.8 Verify Permissions and Ownership on /etc/gshadow ',
		'Section 7.1.1 - 7.1.3 Set Password Expireation  Change Expiring Warning Days Change Minmum Number of Days',
		'Section 7.2 Disable System Accounts',
		'Section 7.3 Set Default Group for root Account',
		'Section 7.4 set Default Umask for Users',
		'Section 7.5 Lock Inactive User Accounts',
		'Section 9.2.1 Ensure Password Fields are Not Empty',
		'Section 9.2.2 - 9.2.4 Verify No Legacy "+" Entries Exist in /etc/passwd /etc/shadow /etc/group File']
     b_list = [ 'A=`stat -c "%u %g" /etc/grub.conf|egrep "0 0"`;if [ "$A" = "0 0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`stat -c "%a %u %g" /etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d | egrep ".00 0 0"`;if [ "$A" = "" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`stat -L -c "%a" /etc/grub.conf|egrep ".00"`;if [ "$A" = "600" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/ssh/sshd_config | awk \'{print $1}\'`;if [ "$A" = "-rw-------." ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/passwd  | awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then echo "PASS";else echo "NO PASS";fi', 
		 'A=`ls -l /etc/group | awk \'{print $1}\'`;if [ "$A" = "-rw-r--r--." ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l /etc/shadow | awk \'{print $1}\'`;if [ "$A" = "----------." ];then echo "PASS";else echo "NO PASS";fi',
		'A=`ls -l  /etc/gshadow | awk \'{print $1}\'`;if [ "$A" = "----------." ];then echo "PASS";else echo "NO PASS";fi',
		'grep "PASS_MAX_DAYS" /etc/login.defs | grep 90  > /dev/null && grep "PASS_MIN_DAYS"  /etc/login.defs | grep 7 > /dev/null && grep "PASS_WARN_AGE" /etc/login.defs | grep 7 > /dev/null ;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`egrep -v "^\+" /etc/passwd |awk -F : \'($1 != "root" && $1 !="sync" && $1 != "shutdown" && $1 !="halt" && $3 < 500 && $7 != "/sbin/nologin"){print}\'`;if [ "$A" = "" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`grep "^root:" /etc/passwd| cut -f4 -d:`;if [ "$A" = "0" ];then echo "PASS";else echo "NO PASS";fi',
		'grep "umask" /etc/bashrc |grep "077" > /dev/null && grep "umask" /etc/profile | grep "077" > /dev/null;if [ "$?" = "0" ];then echo "PASS";else echo "NO PASS";fi ',
		'A=`useradd -D | grep INACTIVE`;if [ "$A" = "INACTIVE=-1" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`cat /etc/shadow | awk -F : \'($2 == ""){print $1 "Does not hava a password"}\'`;if [ "$A" = "" ];then echo "PASS";else echo "NO PASS";fi',
		'A=`grep "^+:" /etc/{shadow,passwd,group}`;if [ "$A" = "" ];then echo "PASS";else echo "NO PASS";fi']

     FILENAME = FILE()
     x=0
     while  x<15 :
	os.system("echo ====================="+a_list[x]+"==================>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)
	os.system(b_list[x]+">>"+FILENAME)
	x = x+1
#	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system("echo ' '>>"+FILENAME)

#Return system Date
def NOWTIME():
    from datetime import date
    import time 
    now = date.today()
    return now.strftime("%Y%b%d")+"_"+time.strftime('%H%M')
#    return now.strftime("%Y%b%d")

#Return filename of Check Resule

def FILE():
    import os
    if os.path.exists('/tmp/OS_CHECK'):
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN
    else:
        os.system('mkdir -p /tmp/OS_CHECK')
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN

MAIN()
