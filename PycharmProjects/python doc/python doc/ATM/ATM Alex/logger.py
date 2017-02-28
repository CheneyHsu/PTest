#!/usr/bin/env python

import time

logfile = 'account.log'

def record_log(account,expense,description,interest = 0):
	date = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
	record_line = "%s 	%s	'%s'	%s	%s\n" %(account,date,description, expense,interest)
	f= file('logfile','a')
	f.write(record_line)
	f.flush()
	f.close()



#loggrep can grep date
