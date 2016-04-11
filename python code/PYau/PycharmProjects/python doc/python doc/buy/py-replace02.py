#!/usr/bin/python
import fileinput
for line in fileinput.input("oldboy.txt",inplace=1):
   line = line.replace("oldtext","newtext")
   print line,
