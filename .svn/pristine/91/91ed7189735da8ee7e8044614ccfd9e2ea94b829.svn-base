#!/usr/bin/python
#coding=utf-8
#file : netiostat


from __future__ import division
import sys
import os
import time
import signal

#netcmd = '/sbin/ifconfig eth0 | grep bytes'
netline=[]
os.system("ifconfig -a | grep -E 'bond|eth' | awk \'{print $1}\' > ./netnum")
f=open('./netnum','r')
for line in f.readlines():
        new_line = line.splitlines()
        netline.extend(new_line)
i
netcmd = '/sbin/ifconfig  | grep bytes'

def getnetio(line):
    s1 = line.find('RX bytes:')+9
    e1 = line.find(' ', s1)
    neti = line[s1:e1]
    s2 = line.find('TX bytes:')+9
    e2 = line.find(' ', s2)
    neto = line[s2:e2]
    return (int(neti), int(neto))


def int_handler(signum, frame):
    print ""
    sys.exit()

signal.signal(signal.SIGINT, int_handler)


line = os.popen(netcmd).readline().strip()
print line
netio = getnetio(line)
neti_start = netio[0]
neto_start = netio[1]
time_start = time.time()
count = 60
while (count > 0):
    count -= 1
    time.sleep(1);
    info = []
    line = os.popen(netcmd).readline().strip()
    netio = getnetio(line)
    info.append("网络流入总量:%.4fm, 网络流出总量:%.4fm" % (netio[0]/1024/1024, netio[1]/1024/1024))
    time_curr = time.time()
    neti_total = netio[0]-neti_start
    neto_total = netio[1]-neto_start
    sec_total = time_curr-time_start
    neti_start = netio[0]
    neto_start = netio[1]
    time_start = time_curr
    info.append("当前网络流入速度:%.4fk/s" % (neti_total/sec_total/1024))
    info.append("当前网络流出速度:%.4fk/s" % (neto_total/sec_total/1024))
    show = ", ".join(info)
    sys.stdout.write(show+"\r")
    sys.stdout.flush()

print ""
