#!/usr/bin/env python

def sayHi(n):
	print "\033[31;1m Hello, %s, How are you? \033[0m" % n

namelist = '../Lession1/namelist2'

f = file(namelist)
for line in f.readlines():
	name = line.split()[1]
	sayHi(name)
