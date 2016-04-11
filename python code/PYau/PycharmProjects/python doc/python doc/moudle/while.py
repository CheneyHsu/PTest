#!/usr/bin/env python


while True:
	input = raw_input("Pls input your name:")
	if input == 'Alex':
		password = raw_input("Pls input your pass:")
		p = 'redhat'
		while password != p:
			password = raw_input("Pls input your pass:\n")
		else:
			print "Welcome login while test.\n"
			break
	else:
		print "Sorry, user %s not found" % input
		
