#!/usr/bin/env python
#-*- coding:utf-8 -*-
# Filename:    dns example
# Revision:    1.0
### END INIT INFO

'''
��װ��ʹ�ã�
	1������dns.tar.gz
	2����װ��
		ϵͳ��װGCC��python-devel
	3����װָ�
		python setup.py install
'''

print "A"

import dns.resolver
domain=raw_input('Please input an domain:')
A=dns.resolver.query(domain,'A')
for i in A.response.answer:
	for j in i.items:
		print j.address
		
print "MX"
domain=raw_input('Please input an domain:')
MX=dns.resolver.query(domain,'MX')
for i in MX:
	print 'MX preference =', i.preference, 'mail exchanger = ', i.exchange
	
	
	
print "NS"
#ֻ������1������  �� Cname ͬ���
import dns.resolver
domain=raw_input('Please input an domain:')
ns=dns.resolver.query(domain,'NS')
for i in ns.response.answer:
	for j in i.items:
		print j.to_text()