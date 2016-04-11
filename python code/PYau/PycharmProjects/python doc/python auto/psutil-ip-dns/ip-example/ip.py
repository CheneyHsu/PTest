#!/usr/bin/env python
#-*- coding:utf-8 -*-
# Filename:    IPy example
# Revision:    1.0
### END INIT INFO

'''
��װ��ʹ�ã�
	1������IPy.tar.gz
	2����װ��
		ϵͳ��װGCC��python-devel
	3����װָ�
		python setup.py install
'''

from IPy import IP 
ip_s = raw_input('Pls input an IP or net-range:')
ips=IP(ip_s)
if len(ips)>1:
	print ('net: %s' % ips.net())
	print ('netmask: %s' % ips.netmask())
	print ('broadcast : %s' % ips.broadcast())
	print ('reverse address: %s' % ips.reverseNames()[0])
	print ('subnet: %s' % len(ips))
else:
	print ('reverse address: %s' % ips.reverseNames()[0])
	
print ('hexadecimal: %s' % ips.strHex())
print ('binary ip: %s' % ips.strBin())
print ('iptype: %s' % ips.iptype())

A=IP('192.168.1.23') in IP('192.168.1.0/24')
print A






