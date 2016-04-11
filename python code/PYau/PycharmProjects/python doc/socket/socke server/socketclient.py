#!/usr/bin/env python
# _*_ coding:utf-_8 _*_
__author__ = 'CheneyHsu'

import socket

h = 'localhost'
p = 9990
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((h,p))
while 1:
	INPUT = raw_input("Input:")
	s.send(INPUT)
	received_data = s.recv(4096)
        print "Received from server:", received_data
s.close()
