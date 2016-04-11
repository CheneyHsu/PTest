#!/usr/bin/env  python
#-*- coding:utf-8 -*-
# Revision:    1.0
### END INIT INFO

"""
对比2个配置文件的不同
"""


__author__ = 'KK'


import difflib
import sys
try:
    textfile1=sys.argv[1]
    textfile2=sys.argv[2]
except Exception,e:
    print "Error:"+str(e)
    print "Usage: simple3.py filename1 filename2"
    sys.exit(1)

def readfile(filename):
    try:
        fileHandle = open(filename,'rb')
        text=fileHandle.read().splitlines()
        fileHandle.close()
        return text
    except IOError as error:
        print('Read file Error:'+str(error))
        sys.exit(1)

if textfile1=="" or textfile2=="":
    print "Usage: simple3.py filename1 filename2"
    sys.exit(1)

text1_lines = readfile(textfile1)
text2_lines = readfile(textfile2)

d =difflib.HtmlDiff()
print d.make_file(text1_lines,text2_lines)