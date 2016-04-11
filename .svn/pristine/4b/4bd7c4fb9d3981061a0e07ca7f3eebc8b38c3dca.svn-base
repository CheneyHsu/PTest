#!/usr/bin/env python
#import tab
import socket

h = '10.0.0.19'
p = 9999 
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((h,p))
while 1:
        INPUT = raw_input("Input:")
        s.send(INPUT)
        received_data = s.recv(8096)


        print "Received from server:", received_data
s.close()
