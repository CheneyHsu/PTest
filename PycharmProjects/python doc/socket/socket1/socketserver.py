__author__ = 'CheneyHsu'
#!/usr/bin/env python
# _*_ coding:utf-_8 _*_

import os
import socket
import time

host = ''
port = 18001
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.bind((host,port))
s.listen(1)

#while 1:
conn, addr = s.accept()

#----------
print 'Got connection from:', addr
while 1:
		data = conn.recv(4096)
		print 'get data',data
		if not data:
			time.sleep(1.5)
			#break
		cmd = os.popen(data)
		result = cmd.read()
		#print result
		feedback = '\033[32;1mFeedback of the cmd\033[0m\n' +result
		conn.sendall(feedback)

conn.close()

