#!/usr/bin/env python

def name_info(name,age,job,nationnality='Chinese'):
	global ll
	ll = 'test'
	print ''' 
	%s 's information:
	Name: 	%s
	Age:	%s
	Job:	%s
	Country:	%s ''' % (name,name,age,job,nationnality)
	
	return 'success',ll

name_info('Cxu',31,'IT')
result = name_info('LNGZ',31,'IT')
print 'global variable is : ', ll
print result
if result == 'success':print 'the function is excuted properly'
