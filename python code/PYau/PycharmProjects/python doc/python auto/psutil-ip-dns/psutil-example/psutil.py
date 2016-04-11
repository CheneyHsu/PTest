#!/usr/bin/env python
#-*- coding:utf-8 -*-
# Filename:    psutil example
# Revision:    1.0
### END INIT INFO

'''
psutil ��װ��ʹ�ã�
	1������psutil
		pypi.python.org
	2����װ��
		ϵͳ��װGCC��python-devel
	3����װָ�
		python setup.py install
'''

import psutil

print "Cpu example:"
A=psutil.cpu_times()
B=psutil.cpu_times().user
C=psutil.cpu_times(percpu=True)
D=psutil.cpu_count()
E=psutil.cpu_count(logical=False)
print A
print B
print C
print D
print E

print "Meminfo example:"
mem=psutil.virtual_memory()
B=mem.total
print B
C=mem.free
print C
D=psutil.swap_memory()
print D

print "Diskinfo example:"
A=psutil.disk_partitions()
print A
B=psutil.disk_usage('/')
print B
C=psutil.disk_io_counters()
print C
D=psutil.disk_io_counters(perdisk=True)
print D


print "netinfo example:"
A=psutil.net_io_counters()
print A
B=psutil.net_io_counters(pernic=True)
print B

print "other info example:"
A=psutil.users()
print A
import datetime
B=psutil.boot_time()
print B
C=datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")
print C

print "process exmaple:"
A=psutil.pids()
print A
p=psutil.Process(2704)
B=p.name()
print B
C=p.exe()
print C
D=p.cwd()
print D
E=p.status()
print E
F=p.create_time()
print F
G=p.uids()
print G
H=p.gids()
print H
I=p.cpu_times()
print I
J=p.cpu_affinity()
print J
K=p.memory_percent()
print K
L=p.memory_info()
print L
M=p.io_counters()
print M
N=p.connections()
print N
O=p.num_threads()
print O

print "popen example ,��Ҫ���ڸ��ٽ���"
#import subprocess
from subprocess import PIPE
#ͨ��popen�ķ������������Ը��ٽ�����Ϣ
p=psutil.Popen(["/usr/bin/python","-c","print('hello')"], stdout=PIPE)
A=p.name()
print A
B=p.username()
print B 

C=p.communicate()
print C 

#�ڵ���
#D=p.cpu_times()
#print D

