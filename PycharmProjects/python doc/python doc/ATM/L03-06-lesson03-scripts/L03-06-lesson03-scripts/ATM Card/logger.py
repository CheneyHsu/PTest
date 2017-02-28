#!/usr/bin/env python

# this scripts comes from oldboy trainning.
# e_mail:70271111@qq.com
# qqinfo:49000448
# function: python.
# version:1.1 
################################################
# oldboy trainning info.      
# QQ 80042789 70271111
# site:http://www.etiantian.org
# blog:http://oldboy.blog.51cto.com
# oldboy trainning QQ group: 208160987 45039636
################################################
## this is a program for recording logs,the simple usage as below:
#author :alex
#last update: 1999-04-43
#version : 3.2 

import time
logfile = 'account.log'

def record_log(account,expense,description,interest = 0):
	date = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
	record_line = "%s	%s	'%s'	%s 	%s\n" %(date,account, description, expense, interest)
	f = file(logfile,'a')
	f.write(record_line)
	f.flush()
	f.close()

print 'dfsfaas;ff'

