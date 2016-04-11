#!/usr/bin/env python

import rlcompleter,readline
readline.parse_and_bind('tab: complete')



f = file('namelist2')
contact_dic = {}
for line in f.readlines():
	name = line.split()[1]
	contact_dic[name] = line

for n,v in contact_dic.items():
	print "%s \t %s" % (n,v),

while True:
	input = raw_input("Pls input the staff name:").strip()
	if len(input) == 0:continue
#	print input
#	print contact_dic[input]
	if contact_dic.has_key(input):
		print "\033[31;1m %s \033[0m" % contact_dic[input]
	else:
		print "Sorry , No staff name found!"
