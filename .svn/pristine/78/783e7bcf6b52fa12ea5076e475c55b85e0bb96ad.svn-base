#!/usr/bin/env python
# -*- coding:gb18030 -*-


import os
import time
import sys
import commands
from kkdef import FILE

os.system('bash /usr/report/oraclemakecomment.sh')
commandlines = []
f = file('/usr/report/command')
for line in f.readlines():
        new_line = line.splitlines()
        commandlines.extend(new_line)

commentlines = []
c = file('/usr/report/comment')
for line in c.readlines():
	c_line = line.splitlines()
	commentlines.extend(c_line)

oraclecomments = []
try:
	o = file('/usr/report/oraclecomment')
	for line in o.readlines():
		o_line = line.splitlines()
		oraclecomments.extend(o_line)
except IOError:
	print 'ok'

def MAIN():
	HT()
	HTCOM()
	COMMAND()
	ORACLE()
def HT():
	Hname = commands.getoutput('hostname')
	Htime = commands.getoutput('date +%Y%m%d-%H')
	Hid = commands.getoutput('grep HXSERVERID /etc/profile|awk -F "=" \'{print $2}\'')
	FILENAME = FILE()
    	os.system("echo '<HTML><HEAD><TITLE>'>>"+FILENAME)
    	os.system("echo '</TITLE></HEAD><BODY><H1 align=center>"+Hname+"</H1><PRE>'>>"+FILENAME)
    	os.system("echo '<meta http-equiv='Content-Type' content='text/html' >'>>"+FILENAME)
	os.system("echo '<font size=3><p align=right>Check Date:"+Htime+"</font>'>>"+FILENAME)
	os.system("echo '<font size=3><p align=right>SYSTEM ID:"+Hid+"</font>'>>"+FILENAME)
    	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)

def HTCOM():
	FILENAME = FILE()
	x = 0 
	y = 0
	os.system("echo '<table style=\"TABLE-LAYOUT: fixed\" border=0 cellspacing=10 cellpadding=0>'>>"+FILENAME)
	os.system("echo '<tr>'>>"+FILENAME)
	while x<42:
		if x%10==0:
			        os.system("echo '<tr>'>>"+FILENAME)
		os.system("echo '<td valign=top>'>>"+FILENAME)
		
		os.system("echo '<p><a href=#"+commentlines[x]+">"+commentlines[x]+"</a></p>'>>"+FILENAME)
		x = x + 1
	oracle=os.system('ps -ef | grep -v grep|grep ora_ckpt')
	if oracle == 0:		
		while y<47:
			if y%10==0:
				os.system("echo '<tr>'>>"+FILENAME)
                	os.system("echo '<td valign=top>'>>"+FILENAME)

                	os.system("echo '<p><a href=#"+oraclecomments[y]+">"+oraclecomments[y]+"</a></p>'>>"+FILENAME)
                	y = y + 1		
	os.system("echo '</td></tr></table>'>>"+FILENAME)
	os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)

def COMMAND():
	FILENAME = FILE()
	x = 0
	while  x<42 :
		os.system("echo '<a name="+commentlines[x]+"></b></H2>'>>"+FILENAME)
   		os.system("echo '<H2><b>"+commentlines[x]+"</H2></b><p>'>>"+FILENAME)
		os.system("echo '<font size=4><xmp>'>>"+FILENAME)
		os.system(commandlines[x]+">>"+FILENAME)
		os.system("echo '</xmp></font>'>>"+FILENAME) 
		x = x+1
		os.system("echo '</i></font><a href=\"#top\">返回页首</a>'>>"+FILENAME)
		os.system("echo '<hr size=2 width=100% color=#ff0000>'>>"+FILENAME)

def ORACLE():
	FILENAME = FILE()
	oracle=os.system('ps -ef | grep -v grep|grep ora_ckpt')
	if oracle == 0:
		os.system('bash /usr/report/chkoracle.sh')

MAIN()

