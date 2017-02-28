#!/usr/bin/env python

from ftplib import FTP
import os
import ftplib
from ftpip import testftpip
import commands


upip=commands.getoutput('cat /usr/report/ftpiptrue')

print upip


FNdown=('report.tar')
ftp=FTP()
ftp.set_debuglevel(2) 
ftp.connect(upip,'21')
ftp.login('ftp','ftp') 
ftp.cwd('pub/') 
bufsize = 8192
filename = (FNdown) 
file_handler = open('/usr/report/report.tar','wb').write
try:
	ftp.retrbinary('RETR %s' % os.path.basename(filename),file_handler,bufsize) 
except ftplib.error_perm:
	print 'no file'
#	return 1:
	os.unlink(filename)
#ftp.set_debuglevel(0) 
else:
	print 'ok'
#	file_handler.close() 
	ftp.quit()
	os.system('bash /usr/report/update.sh')
