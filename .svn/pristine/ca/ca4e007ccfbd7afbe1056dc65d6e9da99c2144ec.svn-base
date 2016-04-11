#!/usr/bin/env python 
import SocketServer
import os 
from time import ctime,sleep
HOST = '' 
PORT = 21567 
ADDR = (HOST, PORT) 
class MyRequestHandler(SocketServer.BaseRequestHandler): 
    def handle(self): 
        print '...connected from:', self.client_address 
	#print self.request.recv(1024)
	#self.request.send('Username')
	#----------Auth part----------
	if self.request.recv(1024) == 'auth':
		print 'auth'
		while 1:
			self.request.send('Username')
			username = self.request.recv(1024)
		
			if username == 'alex':
				self.request.send('correct')
				print 'Correct! Welcome!'
				break
			else:
				self.request.send('incorrect')
				continue
        def SendFromClient(filename):
		print 'start receiving data'
                f = file(filename,'wb')
                while True:
                        data = self.request.recv(4096)
                        if data == 'file_send_done':break 
			f.write(data)
		f.close()
		print 'File %s  receive done!' % filename
	def SendToClient(filename):
		print 'start sending file to client..'
		f = file(filename,'rb')
		#while True:
		file_data = f.read()
		#	if not file_data:break
		
		self.request.sendall(file_data)
		f.close()
        	print 'file %s sent to client finished!' % filename
		sleep(0.5)
        	self.request.send('file_send_to_client_done')
	
	#ftp()
	while True:
	  try:
                re_msg = self.request.recv(1024)
                print 'get',re_msg
                if re_msg.split()[0] == 'send':
			filename = re_msg.split()[1]
                        self.request.send('ok2send')
                        print 'ready to receive file from %s' % self.client_address[0]
                        SendFromClient(filename)
                elif re_msg.split()[0] == 'get':
			filename = re_msg.split()[1]
			try:
				os.stat(filename)
			except OSError:
                                msg = '\033[31;1mNo file %s found on FTP server\033[0m' % filename
                                self.request.send(msg)
				print msg
			else:
                        	self.request.send('ok2get')
				sleep(0.5)			
				print 'ready to send file to client %s .' % self.client_address[0]
				SendToClient(filename)	
			
		elif re_msg == 'help' or re_msg == '?':
			help_msg = '''\033[32;1m\nhelp\nget filename\tget file from FTP server\nsend filename\tsend file to FTP server\nls\t\tshow file list on FTP server\033[0m'''
			self.request.send(help_msg)	
		elif re_msg == 'ls':
			print 'print dir list',re_msg
			#file_list = os.listdir('.')
			#convert2string = '\t'.join(file_list)
			file_list = os.popen('ls -lth')
			f_list = file_list.read()
			self.request.sendall(f_list)
			
                else:
                        print 'invalid instruction'
                        self.request.send('\033[31;1minvalid_instruction\033[0m')
	    		print "get from %s: %s" %(self.client_address[0], re_msg )
            		#self.request.sendall('[%s] %s' % (ctime(),re_msg)) 
	  except IndexError:
		print '%s client %s logout !' %(ctime(),self.client_address[0]) 
		break	
try:
	tcpServ = SocketServer.ThreadingTCPServer(ADDR, MyRequestHandler) 
	print 'waiting for connection...' 
	tcpServ.serve_forever()
except socket.error,e:
	print 'error happend!'
