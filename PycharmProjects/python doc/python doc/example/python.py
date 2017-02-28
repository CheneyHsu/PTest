#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Created on 2010-7-2

@author: forever
'''

import sys
import threading
from urllib import urlopen

urls = ["/archive/2010/07/03/5711257.aspx",
"/archive/2010/06/28/5699311.aspx",
"/archive/2010/07/03/5711270.aspx",
]

visitTimesPerPage = 20

def usage():
	print 'Usage:', sys.argv[0], 'host'

def main(argv):
	host = argv[1]
	if host == '':
		usage()
		sys.exit(2)
	else:
		for i in range(visitTimesPerPage):
			for url in urls:
				visitPageThread = VisitPageThread(url + str(i), host, url)
				visitPageThread.start()


class VisitPageThread(threading.Thread):
	def __init__(self, threadName, host, url):
		threading.Thread.__init__(self, name = threadName)
		self.host = host
		self.url = url
	
	def run(self):
		url = self.host + self.url
		try:
			doc = urlopen(url).read()
            #print doc
		except Exception, e:
			print "urlopen Exception : %s" %e


if __name__=='__main__':
	sys.argv.append('http://blog.csdn.net/forandever')
	main(sys.argv)

	
	
	