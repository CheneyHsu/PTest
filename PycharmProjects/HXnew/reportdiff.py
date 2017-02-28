#!/usr/bin/env python
# -*- coding:utf_8 -*-


import os
import time
import sys
import commands
from kkdef import FILEDIFF
os.system('bash /usr/report/reportdiffsh.sh')

def MAIN():
	HT()
	COMMAND()

def HT():
#	Hname = commands.getoutput('hostname')
	Htime = commands.getoutput('date +%Y%m%d%H')
	Hid = commands.getoutput('grep HXSERVERID /etc/profile|awk -F "=" \'{print $2}\'')
	FILENAME = FILEDIFF()
	Hostinfo = './'+Hid+'/'+Hid+'.'+Htime+'.html'
#    	os.system("echo '<HTML><HEAD><TITLE>'>>"+FILENAME)
#    	os.system("echo '</TITLE></HEAD><BODY><H1 align=center>"+Hname+"</H1><PRE>'>>"+FILENAME)
#    	os.system("echo '</TITLE></HEAD><BODY><PRE>'>>"+FILENAME)
    	os.system("echo '<PRE>'>>"+FILENAME)
    	os.system("echo '<meta http-equiv='Content-Type' content='text/html' >'>>"+FILENAME)
	os.system("echo '<font size=3><p align=right>Check Date:"+Htime+"</font></p>'>>"+FILENAME)
#	os.system("echo '<font size=3><p align=right>SYSTEM ID:"+Hid+"</font>'>>"+FILENAME)
#    	os.system("echo '<hr size=0 width=0% color=#ff0000>'>>"+FILENAME)
	os.system("echo '<a href='"+Hostinfo+"'>'"+Htime+"'</a>'>>"+FILENAME)

def COMMAND():
#	commandsh = os.listdir('/usr/report/DIFF/')
	commandsh=['netdiff.sh','userdiff.sh','diskdiffandwr.sh','memdiff.sh','erlog.sh']
	FILENAME = FILEDIFF()
	f=open(FILENAME,'a+')
	x=0
	while x<5:
		results = commands.getoutput('bash /usr/report/DIFF/'+commandsh[x])
		print results 
		f.write(results+'\n')
		x=x+1
	f.close()
	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)
	os.system('python /usr/report/ftpup.py')
MAIN()

