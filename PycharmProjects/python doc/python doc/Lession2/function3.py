#!/usr/bin/env python

def info(name,value):
	print "\033[33;1m Name: %s \t Value: %s \033[0m" %(name,value)

namelist='../Lession1/namelist2'
f = file(namelist)
for line in f.readlines():
	name = line.split()[1]
	value = line.split()[2]
	info(name,value)
