#!/usr/bin/env python
import os
import SocketServer

class myTCPHandler(SocketServer.BaseRequestHandler):
	def handle(self):
		print "got connection from:", self.client_address
		while 1:
			self.data  = self.request.recv(4096)
			if self.data == 'auth':
				print 'client is asking for login'
				self.request.send('ok2auth')
				if self.request.recv(1024) == 'alex':
					print 'user alex login success!'
					self.request.send("\033[32;1mWelcome log on Alex Ftp site! Enjoy!\033[0m")
				else:
					self.request.send("\033[31;1mWrong username\033[0m")	
					continue
				
			self.request.sendall(self.data)
			print 'send data to client '


h,p = '',9999
try:
	server = SocketServer.ThreadingTCPServer((h,p), myTCPHandler)
	server.serve_forever()
except KeyboardInterrupt:
	server.shutdown()
