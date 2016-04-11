#!/usr/bin/env python
import re

pattern = re.compile(r'hello')
match = pattern.match('hello world')

if match:
	print match.group()


m = re.match(r'hello','hello world')
print m.group()

p=re.compile(r'\d+')
print p.split('one1two2three3four4five')
print p.findall('one1two2three3four4five')

t1=re.sub('[abc]','o','Mark')
print t1
t2=re.sub('[abc]','o','rock')
print t2
t3=re.sub('[abc]','o','caps')
print t3
