#!/usr/bin/env python

# this scripts comes from oldboy trainning.
# e_mail:70271111@qq.com
# qqinfo:49000448
# function: python.
# version:1.1 
################################################
# oldboy trainning info.      
# QQ 80042789 70271111
# site:http://www.etiantian.org
# blog:http://oldboy.blog.51cto.com
# oldboy trainning QQ group: 208160987 45039636
################################################
import pickle 

f =  open('acc.pkl','r')
account_info = pickle.load(f)
f.close()

account_info['654321'][1] = 2100
account_info['654321'][2] = 100

f = open('acc.pkl','w')
pickle.dump(account_info,f)

f.close()
