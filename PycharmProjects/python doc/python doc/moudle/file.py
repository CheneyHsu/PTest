#!/usr/bin/env python

with open('file2',"r+") as f:
	old = f.read()
	f.seek(12)
	f.write("new line\n" + old)
