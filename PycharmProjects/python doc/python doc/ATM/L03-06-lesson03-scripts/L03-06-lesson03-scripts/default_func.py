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

def name_info(name,age,job,nationnality='Chinese'):
	global ll 
	ll = 'DDDD'	
	print '''%s 's information:
	Name:	%s
	Age:	%s
	Job:	%s
	Country:	%s ''' % (name,name, age,job,nationnality)
	return 'success',ll
name_info('ZhengDongxu',23,'IT','American')
result = name_info('ShanDongBigBrother',25,'Engineer')
print 'global variable is :',ll
print result 
if result == 'success':print 'the function is excuted properly '
