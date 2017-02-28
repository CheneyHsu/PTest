#!/usr/bin/env python 
# -*- coding: utf-8 -*- 


from ftplib import FTP 
import os,commands
from kkdef import FILE
from kkdef import FILEDIFF
from ftpip import testftpip

print FILE
print testftpip

upip=commands.getoutput('cat /usr/report/ftpiptrue')

print upip


FNDIFF = FILEDIFF()
FNtest = FILE()
#def ftp_up(filename = "/tmp/report/L001.*.html"): 
filename = (FNtest)
filename2 = (FNDIFF) 
ftp=FTP() 
ftp.set_debuglevel(2) 
ftp.connect(upip,'21') 
ftp.login('ftp','ftp') 
ftp.cwd('pub/') 
bufsize = 8192
file_handler = open(filename,'rb')
file_handler2 = open(filename2,'rb')
print file_handler
ftp.storbinary('STOR %s' % os.path.basename(filename),file_handler,bufsize) 
ftp.storbinary('STOR %s' % os.path.basename(filename2),file_handler2,bufsize) 
ftp.set_debuglevel(2) 
file_handler.close() 
file_handler2.close()
ftp.quit()
os.system('logger Linux html upload is ok')
