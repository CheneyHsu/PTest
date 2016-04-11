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
from multiprocessing import Pool as ThreadPool


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
    'extract -f /tmp/log/ovpa/global.txt -g -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/ovpa/application.txt -a -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/transaction.txt -t -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/process.txt -p -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/disk.txt -d -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/volume.txt -z -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/network.txt -n -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/filesystem.txt -y -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/cpu.txt -u -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/globala.txt -G -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/applicationa.txt -A -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/transactiona.txt -T -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/diska.txt -D -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/volumea.txt -Z -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/networka.txt -N -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/filesystema.txt -Y -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/cpua.txt -U -xp > /dev/null 2>&1',
    'extract -f /tmp/log/ovpa/localsystem.txt -I -xp > /dev/null 2>&1',
    'cp -rf /var/log/{message*,cron*,dmesg,mcelog,boot.log,secure,yum.log}   /tmp/log/messagelog/',
    'pstree -a > /tmp/log/ps/pstree-a',
    'ps -ef > /tmp/log/ps/ps-ef',
    'netstat -anp > /tmp/log/netstat/netstat-anp',
    'netstat -s > /tmp/log/netstat/netstat-s',
    'sysctl -a > /tmp/log/osinfo/sysctl-a',
    'uname -a > /tmp/log/osinfo/uname-a',
    'lsmod > /tmp/log/osinfo/lsmod',
    'env > /tmp/log/osinfo/env',
    'cp -rf /var/log/sa/sa??  /tmp/log/sa/',
    'cat /proc/meminfo > /tmp/log/mem/meminfo',
    'free -m > /tmp/log/mem/freem',
    'ipcs -asmq > /tmp/log/ipcs/ipcs-asmp',
    'ipcs -tclup > /tmp/log/ipcs/ipcs-tlup',
    'vmstat 2 5 > /tmp/log/mem/vmstat',
    'df -hlP > /tmp/log/disk/df-hlp',
    'df -hilP > /tmp/log/disk/df-hilp',
    'fdisk -l > /tmp/log/disk/fdisk-l',
    'vgdisplay   > /tmp/log/lvm/vgdisplay',
    'lvdisplay   > /tmp/log/lvm/lvdisplay',
    'pvdisplay   > /tmp/log/lvm/pvdisplay',
    'cp -rf /etc/lvm	 /tmp/log/lvm/',
    'dmsetup ls --tree > /tmp/log/disk/dmsetup-ls-tree',
    'cp -rf /etc/security/limits.conf  /tmp/log/osinfo/limits',
    'cat /var/spool/cron/* > /tmp/log/osinfo/crontab',
    'cp -rf /etc/sudoers  /tmp/log/osinfo/',
    'cp -rf /etc/selinux/config  /tmp/log/osinfo/',
    'last > /tmp/log/osinfo/lastlogin',
    'ip addr show > /tmp/log/net/ipaddr',
    'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool -i $i ;done > /tmp/log/net/ethttool-i',
    'for i in `ifconfig -a |grep eth | awk \'{print $1}\'`;do echo "$i" ; ethtool $i ;done > /tmp/log/net/ethtool',
    'route > /tmp/log/osinfo/route',
    'cp -rf /etc/profile /tmp/log/osinfo/etc-profile',
    'cat /etc/rc.local > /tmp/log/osinfo/rc.local',
    'uptime > /tmp/log/osinfo/uptime',
    'cp -rf /etc/hosts /tmp/log/osinfo/hosts',
    'chkconfig --list > /tmp/log/osinfo/chkconfig',
    'cp -rf  /etc/resolv.conf   /tmp/log/osinfo/',
    'cp -rf /etc/sysconfig/network /tmp/log/osinfo/',
    'iostat 2 5 > /tmp/log/io/iostat',
    'mpstat 2 5 > /tmp/log/cpu/mpstat',
    'iptables -L -n > /tmp/log/osinfo/iptables',
    'ifconfig -a > /tmp/log/net/ifconfig-a',
    'cp /etc/inittab /tmp/log/osinfo/'
    ]

    C_list=[
    'A=`cat /tmp/log/io/io-read-top`;mkdir -p /tmp/log/io/io-read-proc-$A',
    'A=`cat /tmp/log/io/io-write-top`;mkdir -p /tmp/log/io/io-write-proc-$A;',
    'ps aux|grep -v ^\'USER\'|sort -rn -k3|head -10 > /tmp/log/cpu/top-cpu',
    'A=`sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'`;mkdir -p /tmp/log/cpu/top-cpu-proc-$A',
    'ps aux|grep -v ^\'USER\'|sort -rn -k4|head -10 > /tmp/log/mem/top-mem',
    'A=`sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'`;mkdir -p /tmp/log/mem/top-mem-proc-$A']

    B_list =[
    'lsof -p `cat /tmp/log/io/io-read-top` > /tmp/log/io/io-read-lsof',
    'lsof -p `cat /tmp/log/io/io-write-top` > /tmp/log/io/io-write-lsof',
    'A=`cat /tmp/log/io/io-read-top`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i > /tmp/log/io/io-read-proc-$A/$i;done',
    'A=`cat /tmp/log/io/io-write-top`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i > /tmp/log/io/io-write-proc-$A/$i;done',
    'lsof -p `sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'` > /tmp/log/cpu/top-cpu-lsof',
    'A=`sed -n 1p /tmp/log/cpu/top-cpu|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i > /tmp/log/cpu/top-cpu-proc-$A/$i ;done',
    'lsof -p `sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'` > /tmp/log/mem/top-mem-lsof',
    'pmap `sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'` > /tmp/log/mem/top-mem-pmap',
    'A=`sed -n 1p /tmp/log/mem/top-mem|awk \'{print $2}\'`;for i in {cmdline,cpuset,environ,io,limits,maps,mountinfo,mounts,mountstats,numa_maps,sched,smaps,status};do cat /proc/$A/$i > /tmp/log/mem/top-mem-proc-$A/$i;done',
    ]
    C_num = len(C_list)

    pool = ThreadPool(4)
    pool.map(os.system,A_list)
    pool.close()

    x=0
    while x<C_num:
        os.system(C_list[x])
        x=x+1

    pool = ThreadPool(4)
    pool.map(os.system,B_list)
    pool.close()



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
