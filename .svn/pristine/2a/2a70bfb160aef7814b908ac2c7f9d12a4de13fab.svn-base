#!/bin/env python
import sys
# this script is use to read info from file and translate to the dictionary
f = open('shops.txt')
d = f.readlines()
f.close()      
mydict = { }
for i in d:
    product = i.split(' ')[0]
    price = i.split(' ')[1].rstrip()
    print product
    print price
sys.exit()
    mydict = {product:price}
for key,value in mydict.items():
    print "this product and price :%s %s" % (key,value)

