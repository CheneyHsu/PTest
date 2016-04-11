#!/usr/bin/env python
import socket
from time import sleep

h = '10.0.0.19'
p = 18001
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((h,p))


while 1:
	s.send('Hello BigBrother, my name is Anhong!')
	received_data = s.recv(1024)
	sleep(1)

	print "Received from server:", received_data
s.close()
