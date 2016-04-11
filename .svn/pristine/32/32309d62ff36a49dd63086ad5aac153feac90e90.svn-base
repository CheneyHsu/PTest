#!/bin/python
#-*- coding:utf-8 -*-
# Filename:    sos and supersos
# Revision:    1.2
### END INIT INFO

import os
import re
import sys
import time
from string import strip



if os.geteuid() == 0:
    os.system('mkdir -p /tmp/log/{ovpa,messagelog,ps,netstat,osinfo,sa,mem,ipcs,disk,lvm,net,cpu,io}')

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
        f1=open('/tmp/log/io/io-read-top','wb')
        f2=open('/tmp/log/io/io-write-top','wb')
        f1.write(sort_read_dict[0][0])
        f2.write(sort_write_dict[0][0])
        f1.close()
        f2.close()
        # 打印统计结果
        f=open('/tmp/log/io/io-top-all','wb')
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

    A_list = [
    'ps aux|grep -v ^\'USER\'|sort -rn -k4|head -10 1> /tmp/log/mem/top-mem 2>/dev/null &',
    'ps aux|grep -v ^\'USER\'|sort -rn -k3|head -10 1> /tmp/log/cpu/top-cpu 2>/dev/null &',
    'cp -rf /var/log/{message*,cron*,dmesg,mcelog,boot.log,secure,yum.log}   /tmp/log/messagelog/ 2>/dev/null &',
    'pstree -a 1> /tmp/log/ps/pstree-a 2>/dev/null &',
    'ps -ef 1> /tmp/log/ps/ps-ef 2>/dev/null &',
    'netstat -anp 1> /tmp/log/netstat/netstat-anp 2>/dev/null &',
    'netstat -s 1> /tmp/log/netstat/netstat-s 2>/dev/null &',
    'sysctl -a 1> /tmp/log/osinfo/sysctl-a 2>/dev/null &',
    'uname -a 1> /tmp/log/osinfo/uname-a 2>/dev/null &',
    'lsmod 1> /tmp/log/osinfo/lsmod 2>/dev/null &',
    'env 1> /tmp/log/osinfo/env 2>/dev/null &',
    'cp -rf /var/log/sa/sa??  /tmp/log/sa/ 2>/dev/null &',
    'cat /proc/meminfo 1> /tmp/log/mem/meminfo 2>/dev/null &',
    'free -m 1> /tmp/log/mem/freem 2>/dev/null &',
    'ipcs -asmq 1> /tmp/log/ipcs/ipcs-asmp 2>/dev/null &',
    'ipcs -tclup 1> /tmp/log/ipcs/ipcs-tlup 2>/dev/null &',
    'vmstat 2 5 1> /tmp/log/mem/vmstat 2>/dev/null &',
    'df -hlP 1> /tmp/log/disk/df-hlp 2>/dev/null &',
    'df -hilP 1> /tmp/log/disk/df-hilp 2>/dev/null &',
    'fdisk -l 1> /tmp/log/disk/fdisk-l 2>/dev/null &',
    'vgdisplay  1> /tmp/log/lvm/vgdisplay 2>/dev/null &',
    'lvdisplay  1> /tmp/log/lvm/lvdisplay 2>/dev/null &',
    'pvdisplay  1> /tmp/log/lvm/pvdisplay 2>/dev/null &',
    'cp -rf /etc/lvm	 /tmp/log/lvm/ 2>/dev/null &',
    'dmsetup ls --tree 1> /tmp/log/disk/dmsetup-ls-tree 2>/dev/null &',
    'cp -rf /etc/security/limits.conf  /tmp/log/osinfo/limits 2>/dev/null &',
    'cat /var/spool/cron/* 1> /tmp/log/osinfo/crontab 2>/dev/null &',
    'cp -rf /etc/sudoers  /tmp/log/osinfo/ 2>/dev/null &',
    'cp -rf /etc/selinux/config  /tmp/log/osinfo/ 2>/dev/null &',
    'last 1> /tmp/log/osinfo/lastlogin 2>/dev/null &',
    'ip addr show 1> /tmp/log/net/ipaddr 2>/dev/null &',
    'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool -i $i ;done 1> /tmp/log/net/ethttool-i 2>/dev/null &',
    'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool $i ;done 1> /tmp/log/net/ethtool 2>/dev/null &',
    'route 1> /tmp/log/osinfo/route 2>/dev/null &',
    'cp -rf /etc/profile /tmp/log/osinfo/etc-profile 2>/dev/null &',
    'cat /etc/rc.local 1> /tmp/log/osinfo/rc.local  2>/dev/null &',
    'uptime 1> /tmp/log/osinfo/uptime 2>/dev/null &',
    'cp -rf /etc/hosts /tmp/log/osinfo/hosts 2>/dev/null &',
    'chkconfig --list 1> /tmp/log/osinfo/chkconfig 2>/dev/null &',
    'cp -rf  /etc/resolv.conf   /tmp/log/osinfo/ 2>/dev/null &',
    'cp -rf /etc/sysconfig/network /tmp/log/osinfo/ 2>/dev/null &',
    'iostat 2 5 1> /tmp/log/io/iostat 2>/dev/null &',
    'mpstat 2 5 1> /tmp/log/cpu/mpstat 2>/dev/null &',
    'iptables -L -n 1> /tmp/log/osinfo/iptables 2>/dev/null &',
    'ifconfig -a 1> /tmp/log/net/ifconfig-a 2>/dev/null &',
    'cp /etc/inittab /tmp/log/osinfo/ 2>/dev/null &'
    ]

    C_list=[
    'A=`cat /tmp/log/io/io-read-top`;mkdir -p /tmp/log/io/io-read-proc-$A 2>/dev/null ',
    'A=`cat /tmp/log/io/io-write-top`;mkdir -p /tmp/log/io/io-write-proc-$A 2>/dev/null',
    'A=`sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'`;mkdir -p /tmp/log/cpu/top-cpu-proc-$A 2>/dev/null',
    'A=`sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'`;mkdir -p /tmp/log/mem/top-mem-proc-$A 2>/dev/null',
    'extract -f /tmp/log/ovpa/global.txt -g -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/ovpa/application.txt -a -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/transaction.txt -t -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/process.txt -p -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/disk.txt -d -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/volume.txt -z -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/network.txt -n -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/filesystem.txt -y -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/cpu.txt -u -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/globala.txt -G -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/applicationa.txt -A -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/transactiona.txt -T -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/diska.txt -D -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/volumea.txt -Z -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/networka.txt -N -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/filesystema.txt -Y -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/cpua.txt -U -xp > /dev/null 2>&1 ',
    'extract -f /tmp/log/ovpa/localsystem.txt -I -xp > /dev/null 2>&1 ',]

    B_list =[
    'lsof -p `cat /tmp/log/io/io-read-top` 1> /tmp/log/io/io-read-lsof 2>/dev/null &',
    'lsof -p `cat /tmp/log/io/io-write-top` 1> /tmp/log/io/io-write-lsof 2>/dev/null &',
    'A=`cat /tmp/log/io/io-read-top`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i 1> /tmp/log/io/io-read-proc-$A/$i;done 2>/dev/null ',
    'A=`cat /tmp/log/io/io-write-top`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i 1> /tmp/log/io/io-write-proc-$A/$i;done 2>/dev/null ',
    'lsof -p `sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'` 1> /tmp/log/cpu/top-cpu-lsof 2>/dev/null &',
    'A=`sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i 1> /tmp/log/cpu/top-cpu-proc-$A/$i ;done 2>/dev/null ',
    'lsof -p `sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'` 1> /tmp/log/mem/top-mem-lsof 2>/dev/null &',
    'pmap `sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'` 1> /tmp/log/mem/top-mem-pmap 2>/dev/null &',
    'A=`sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i 1> /tmp/log/mem/top-mem-proc-$A/$i;done 2>/dev/null ',
    ]
    C_num = len(C_list)
    A_num = len(A_list)
    B_num = len(B_list)

    y=0
    while y<A_num:
        os.system(A_list[y])
        y=y+1
 
    x=0
    while x<C_num:
        os.system(C_list[x])
        x=x+1

    z=0
    while z<B_num:
        os.system(B_list[z])
        z=z+1


    os.system("tar zcvf /tmp/`hostname`.`date +%y%m%d%H%M`.tar.gz /tmp/log/* > /dev/null 2>&1 ")
    os.system("rm -rf /tmp/log")
	
	
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
