#!/usr/bin/env python
# -*- coding:utf_8 -*- 
#Return OS Method
def PLAT_CHECK():
    try:
        import commands
        PLATFROM = commands.getoutput("uname")
    except ImportError:
        PLATFROM = 'WIN'
    return PLATFROM

#Change OS Method and Call The Function Of Checked
def MAIN():
    PLAT_TEMP= PLAT_CHECK()
    if PLAT_TEMP == 'AIX':
        #Call AIX OS Check
        AIX()
    elif PLAT_TEMP == 'HP-UX':
        #Call HP-UX OS Check
        HPUX()
    elif PLAT_TEMP == 'SunOS':
        #Call SunOS OS Check
        SUN()
    elif PLAT_TEMP == 'Linux':
        #Call Linux OS Check
        LINUX()
    elif PLAT_TEMP == 'WIN':
        #Call Windows OS Check
        WIN()
    else:
        print('The Programe Cannot know what your OS name!')

#Windows System Check
def WIN():
    with open('\counter', mode = 'w', encoding='utf-8') as a_file:
        a_file.write('\Memory\% Committed Bytes In Use\n')
        a_file.write('\Memory\Available MBytes\n')
        a_file.write('\Memory\Cache Faults/sec\n')
        a_file.write('\\Network Interface(*)\Bytes Total\sec\n')
        a_file.write('\PhysicalDisk(*)\% Idle Time\n')
        a_file.write('\PhysicalDisk(*)\Avg.Disk Queue Length\n')
        a_file.write('\Processor Information(*)\% Interrupt Time\n')
        a_file.write('\Processor Information(*)\% Processor Time\n')
        a_file.write('\Processor Information(*)\Parking Status\n')
    import os
    FILE_PERF = '\\tmp\OS_CHECK\OS_CHECK_' +NOWTIME()+ '.csv'
    FILE_TASK = '\\tmp\OS_CHECK\OS_CHECK_' +NOWTIME()+ '.txt'
    print(FILE_PERF)
    print(FILE_TASK)
    os.system('mkdir \\tmp\OS_CHECK')
    os.system('typeperf -cf \counter -si 5 -sc 2 -f CSV -y -o '+FILE_PERF)
    os.system('del \counter')
    os.system('tasklist > '+FILE_TASK)

#Linux System Check
def LINUX():
    LINUXCOMM = []
    LINUXCOMM.append('uname -a')
    LINUXCOMM.append('dmesg')
    LINUXCOMM.append('iostat -x 1 3 ')
    LINUXCOMM.append('vmstat 1 3')
    LINUXCOMM.append('eval top -b -n 1')
    LINUXCOMM.append('ps -elf')
    LINUXCOMM.append('mpstat 1 3')
    LINUXCOMM.append('cat /proc/meminfo')
    LINUXCOMM.append('cat /proc/slabinfo')
    LINUXCOMM.append('df -h')
    LINUXCOMM.append('df -i')
    LINUXCOMM.append('pvs')
    LINUXCOMM.append('vgs')
    LINUXCOMM.append('lvs')
    FILENAME = FILE()
    for i in LINUXCOMM:
        import os
        print(i)
        os.system("echo =================="+i+"==================>>"+FILENAME)
        os.system(i+" >> "+FILENAME)

#Solaris System Check
def SUN():
    SUNCOMM = []
    SUNCOMM.append('uname -a')
    SUNCOMM.append('dmesg')
    SUNCOMM.append('iostat -En')
    SUNCOMM.append('vmstat 1 3 ')
    SUNCOMM.append('top -d1')
    SUNCOMM.append('sar 2 2')
    SUNCOMM.append('ps -elf')
    SUNCOMM.append('mpstat -p')
    SUNCOMM.append('prstat -a -c 1 1')
    SUNCOMM.append('df -k')
    SUNCOMM.append('df -h')
    SUNCOMM.append('df -i')
    SUNCOMM.append('df -F ufs -o i')
    SUNCOMM.append('prtdiag -v')
    SUNCOMM.append('ifconfig -a')
    SUNCOMM.append('psrinfo -v')
    SUNCOMM.append('netstat -rn')
    SUNCOMM.append('prtconf -V')
    SUNCOMM.append('hostname')
    SUNCOMM.append('showrev')
    SUNCOMM.append('hostid')
    SUNCOMM.append('cat /etc/system')
    SUNCOMM.append('swap -s')
    SUNCOMM.append('cat /etc/vfstab')
    SUNCOMM.append('cat /etc/hosts')
    SUNCOMM.append('cat /etc/passwd')
    SUNCOMM.append('crontab -l')
    SUNCOMM.append('env')
    SUNCOMM.append('metastat')
    SUNCOMM.append('vxdisk list')
    SUNCOMM.append('vxprint -v')
    SUNCOMM.append('scstat -g')
    SUNCOMM.append('scrgadm -p')
    SUNCOMM.append('scinstall -pv')
    SUNCOMM.append('hastatus -sum')
    SUNCOMM.append('pkginfo -l')
    SUNCOMM.append('patchadd -p')
    SUNCOMM.append('bpps -a')
    SUNCOMM.append('bpdbjobs')
    SUNCOMM.append('tpconfig -l')
    SUNCOMM.append('bpmedialist')
    SUNCOMM.append('bppllist')
    SUNCOMM.append('usr/openv/netbackup/bin/goodies/available_media')
    FILENAME = FILE()
    for i in SUNCOMM:
        import os
        print(i)
        os.system("echo =================="+i+"==================>>"+FILENAME)
        os.system(i+" >> "+FILENAME)

#HP-UX System Check
def HPUX():
    HPUXCOMM = []
    HPUXCOMM.append('uname -a')
    HPUXCOMM.append('dmesg')
    HPUXCOMM.append('iostat 1 3')
    HPUXCOMM.append('vmstat 1 3')
    HPUXCOMM.append('top -d 1')
    HPUXCOMM.append('ps -elf')
    HPUXCOMM.append('sar -A -S 1 3') 
    HPUXCOMM.append('bdf')
    HPUXCOMM.append('netstat -in')
    HPUXCOMM.append('netstat -rn')
    HPUXCOMM.append('ioscan -funClan')
    HPUXCOMM.append('lanadmin -x -v 900')
    HPUXCOMM.append('model')
    HPUXCOMM.append('ioscan -funCdisk')
    HPUXCOMM.append('cat /etc/fstab')
    HPUXCOMM.append('cat /etc/mnttab')
    HPUXCOMM.append('strings /etc/lvmtab')
    HPUXCOMM.append('cmviewcl -v')
    HPUXCOMM.append('cmviewcl')
    HPUXCOMM.append('cmquerycl')
    HPUXCOMM.append('cmviewconf')
    HPUXCOMM.append('lanscan')
    FILENAME = FILE()
    for i in HPUXCOMM:
        import os
        print(i)
        os.system("echo =================="+i+"==================>>"+FILENAME)
        os.system(i+" >> "+FILENAME)

def AIX():
    AIXCOMM = []
    AIXCOMM.append('iostat 1 3')
    AIXCOMM.append('vmstat 1 3')
    AIXCOMM.append('top -d1')
    AIXCOMM.append('ps -elf')
    AIXCOMM.append('sar -S')
    AIXCOMM.append('df -h')
    AIXCOMM.append('lspv')
    AIXCOMM.append('lsvg')
    AIXCOMM.append('netstat -in')
    AIXCOMM.append('netstat -rn')
    FILENAME = FILE()
    for i in AIXCOMM:
        import os
        print(i)
        os.system("echo =================="+i+"==================>>"+FILENAME)
        os.system(i+" >> "+FILENAME)

#Return System Date
def NOWTIME():
    from datetime import date
    import time
    now = date.today()
    return now.strftime("%Y%b%d")+"_"+time.strftime('%H%M%S')

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
