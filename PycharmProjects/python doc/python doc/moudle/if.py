#!/usr/bin/env python
import os
name=raw_input("Pls input your name:")
age=int(raw_input("Pls input your age:"))
job=raw_input("Pls input your job:")

print "============================================"

if age < 28:
	print "ok"
elif name == "test":
	print "that's ok!"
else :
	print "No!"


print '''
name:%s
age:%s
job:%s
''' % (name,age,job)
