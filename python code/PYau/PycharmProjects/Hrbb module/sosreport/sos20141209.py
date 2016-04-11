#!/bin/python
#-*- coding:utf-8 -*-
# Filename:    sos and supersos
# Revision:    1.0
### END INIT INFO

import os
import re
import sys
import time
from string import strip

A_list = [
'mkdir /tmp/log',
'extract -f /tmp/log/global.txt -g -xp',
'extract -f /tmp/log/application.txt -a -xp',
'extract -f /tmp/log/transaction.txt -t -xp',
'extract -f /tmp/log/process.txt -p -xp',
'extract -f /tmp/log/disk.txt -d -xp',
'extract -f /tmp/log/volume.txt -z -xp',
'extract -f /tmp/log/network.txt -n -xp',
'extract -f /tmp/log/filesystem.txt -y -xp',
'extract -f /tmp/log/cpu.txt -u -xp',
'extract -f /tmp/log/globala.txt -G -xp',
'extract -f /tmp/log/applicationa.txt -A -xp',
'extract -f /tmp/log/transactiona.txt -T -xp',
'extract -f /tmp/log/diska.txt -D -xp',
'extract -f /tmp/log/volumea.txt -Z -xp',
'extract -f /tmp/log/networka.txt -N -xp',
'extract -f /tmp/log/filesystema.txt -Y -xp',
'extract -f /tmp/log/cpua.txt -U -xp',
'extract -f /tmp/log/localsystem.txt -I -xp',
'cp -rf /var/log/{message*,cron*,dmesg,mcelog,boot.log,secure,yum.log}   /tmp/log/',
'pstree -a > /tmp/log/pstreea',
'ps -ef > /tmp/log/psef',
'netstat -anp > /tmp/log/netstatanp',
'netstat -s > /tmp/log/netstats',
'sysctl -a > /tmp/log/sysctla',
'uname -a > /tmp/log/uname',
'lsmod > /tmp/log/lsmod',
'env > /tmp/log/env',
'cp -rf /var/log/sa/sa??  /tmp/log/',
'cat /proc/meminfo > /tmp/log/meminfo',
'free -m > /tmp/log/freem',
'ipcs -asmq > /tmp/log/ipcsasmp',
'ipcs -tclup > /tmp/log/ipcstlup',
'vmstat 2 5 > /tmp/log/vmstat',
'df -hlP > /tmp/log/dfhlp',
'df -hilP > /tmp/log/dfhilp',
'fdisk -l > /tmp/log/fdisk',
'vgdisplay   > /tmp/log/vgdisplay',
'lvdisplay   > /tmp/log/lvdisplay',
'pvdisplay   > /tmp/log/pvdisplay',
'cp -rf /etc/lvm	 /tmp/log',
'dmsetup ls --tree > /tmp/log/dmsetuplstree',
'cp -rf /etc/security/limits.conf  /tmp/log/limits',
'cat /var/spool/cron/* > /tmp/log/crontab',
'cp -rf /etc/sudoers  /tmp/log/',
'cp -rf /etc/selinux/config  /tmp/log/',
'last > /tmp/log/lastlogin',
'ip addr show > /tmp/log/ipaddr',
'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool -i $i ;done > /tmp/log/ethttooli',
'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool $i ;done > /tmp/log/ethtool',
'route > /tmp/log/route',
'cp -rf /etc/profile /tmp/log/etcprofile',
'cat /etc/rc.local > /tmp/log/rc.local',
'uptime > /tmp/log/uptime',
'cp -rf /etc/hosts /tmp/log/hosts',
'chkconfig --list > /tmp/log/chkconfig',
'cp -rf  /etc/resolv.conf   /tmp/log/',
'cp -rf /etc/sysconfig/network /tmp/log/',
'iostat 2 5 > /tmp/log/iostat',
'mpstat 2 5 > /tmp/log/mpstat',
'iptables -L -n > /tmp/log/iptables',
'ifconfig -a > /tmp/log/ifconfignet']


A_num = len(A_list)

if os.geteuid() == 0:
    #基础信息收集
    x=0
    while x < A_num:
        os.system(A_list[x]+"  > /dev/null 2>&1")
        x = x+1
    ###################基本信息抓取完成#############################



    #最高IO抓取前3名详细信息
    sys_proc_path = '/proc/'
    re_find_process_number = '^\d+$'

    ####
    # 通过/proc/$pid/io获取读写信息
    ####
    def collect_info():
        _tmp = {}
        re_find_process_dir = re.compile(re_find_process_number)
        for i in os.listdir(sys_proc_path):
            if re_find_process_dir.search(i):
                # 获得进程名
                process_name = open("%s%s/stat" % (sys_proc_path, i), "rb").read().split(" ")[1]
                # 读取io信息
                rw_io = open("%s%s/io" % (sys_proc_path, i), "rb").readlines()
                for _info in rw_io:
                    cut_info = strip(_info).split(':')
                    if strip(cut_info[0]) == "read_bytes":
                        read_io = int(strip(cut_info[1]))
                    if strip(cut_info[0]) == "write_bytes":
                        write_io = int(strip(cut_info[1]))
                _tmp[i] = {"name":process_name, "read_bytes":read_io, "write_bytes":write_io}
        return _tmp


    def main(_sleep_time, _list_num):
        _sort_read_dict = {}
        _sort_write_dict = {}
        # 获取系统读写数据
        process_info_list_frist = collect_info()
        time.sleep(_sleep_time)
        process_info_list_second = collect_info()
        # 将读数据和写数据进行分组，写入两个字典中
        for loop in process_info_list_second.keys():
            second_read_v = process_info_list_second[loop]["read_bytes"]
            second_write_v = process_info_list_second[loop]["write_bytes"]
            try:
                frist_read_v = process_info_list_frist[loop]["read_bytes"]
            except:
                frist_read_v = 0
            try:
                frist_write_v = process_info_list_frist[loop]["write_bytes"]
            except:
                frist_write_v = 0
            # 计算第二次获得数据域第一次获得数据的差
            _sort_read_dict[loop] = second_read_v - frist_read_v
            _sort_write_dict[loop] = second_write_v - frist_write_v
    # 将读写数据进行排序
        sort_read_dict = sorted(_sort_read_dict.items(),key=lambda _sort_read_dict:_sort_read_dict[1],reverse=True)
        sort_write_dict = sorted(_sort_write_dict.items(),key=lambda _sort_write_dict:_sort_write_dict[1],reverse=True)
        f1=open('/tmp/log/ioread','wb')
        f2=open('/tmp/log/iowrite','wb')
        f1.write(sort_read_dict[0][0])
        f2.write(sort_write_dict[0][0])
        f1.close()
        f2.close()
        # 打印统计结果
        f=open('/tmp/log/iotop','wb')
        f.write('pid     process     read(bytes) pid     process     write(btyes)')
        f.write("\n")
        for _num in range(_list_num):
            read_pid = sort_read_dict[_num][0]
            write_pid = sort_write_dict[_num][0]
            res = "%s" % read_pid
            res += " " * (8 - len(read_pid)) + process_info_list_second[read_pid]["name"]
            res += " " * (12 - len(process_info_list_second[read_pid]["name"])) + "%s" % sort_read_dict[_num][1]
            res += " " * (12 - len("%s" % sort_read_dict[_num][1])) + write_pid
            res += " " * (8 - len(write_pid)) + process_info_list_second[write_pid]["name"]
            res += " " * (12 - len("%s" % process_info_list_second[write_pid]["name"])) + "%s" % sort_write_dict[_num][1]
            #print res
            f.write(res)
            f.write("\n")
        print "\n" * 1
        f.close()

    if __name__ == '__main__':
        try:
            _sleep_time = sys.argv[1]
        except:
            _sleep_time = 3
        try:
            _num = sys.argv[2]
        except:
            _num = 3
        try:
            loop = sys.argv[3]
        except:
            loop = 1
        for i in range(int(loop)):
            main(int(_sleep_time), int(_num))

    #抓取IO最高的值得进程信息
    os.system('lsof -p `cat /tmp/log/ioread` > /tmp/log/ioreadprocess')
    os.system('lsof -p `cat /tmp/log/iowrite` > /tmp/log/iowriteprocess')
    os.system("mkdir -p /tmp/log/ioread`cat /tmp/log/ioread`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/`cat /tmp/log/ioread`/$i > /tmp/log/ioread`cat /tmp/log/ioread`/$i > /dev/null 2>&1;done")
    os.system("mkdir -p /tmp/log/iowrite`cat /tmp/log/iowrite`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/`cat /tmp/log/iowrite`/$i > /tmp/log/iowrite`cat /tmp/log/iowrite`/$i > /dev/null 2>&1;done")


    #cpu使用率最高进程
    os.system("ps aux|grep -v ^'USER'|sort -rn -k3|head -10 > /tmp/log/topcpu")
    os.system("lsof -p `sed -n 1p /tmp/log/topcpu|awk \'{print $2}\'` > /tmp/log/topcpupidinfo ")
    os.system("mkdir -p /tmp/log/topcpu`sed -n 1p /tmp/log/topcpu|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/`sed -n 1p /tmp/log/topcpu|awk \'{print $2}\'`/$i > /tmp/log/topcpu`sed -n 1p /tmp/log/topcpu|awk \'{print $2}\'`/$i > /dev/null 2>&1 ;done")

    #内存使用最高
    os.system("ps aux|grep -v ^'USER'|sort -rn -k4|head -10 > /tmp/log/topmem")
    os.system("lsof -p `sed -n 1p /tmp/log/topmem|awk \'{print $2}\'` > /tmp/log/topmempidinfo ")
    os.system("pmap `sed -n 1p /tmp/log/topmem|awk \'{print $2}\'` > /tmp/log/topmempidinfopmap ")
    os.system("mkdir -p /tmp/log/topmem`sed -n 1p /tmp/log/topmem|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/`sed -n 1p /tmp/log/topmem|awk \'{print $2}\'`/$i > /tmp/log/topmem`sed -n 1p /tmp/log/topmem|awk \'{print $2}\'`/$i > /dev/null 2>&1 ;done")




    os.system("tar zcvf /tmp/`hostname`.`date +%y%m%d%H%M`.tar.gz /tmp/log/* > /dev/null 2>&1 ")
    os.system("rm -rf /tmp/log/*")
	
	
    os.system("echo \"                                               \" ")
    os.system("echo \" ######     #    #    #     #     ####   #    #\" ")
    os.system("echo \" #          #    ##   #     #    #       #    #\" ")
    os.system("echo \" #####      #    # #  #     #     ####   ######\" ")
    os.system("echo \" #          #    #  # #     #         #  #    #\" ")
    os.system("echo \" #          #    #   ##     #    #    #  #    #\" ")
    os.system("echo \" #          #    #    #     #     ####   #    #\" ")
    os.system("echo \"                                               \" ")
else :
    print "This program must be run as root. Aborting."
    sys.exit(1)
