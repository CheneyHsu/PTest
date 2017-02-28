#!/usr/bin/python
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
import time,logger
import sys
#load data frist 
pkl_file = open('account.pkl','rb')
account_list = pickle.load(pkl_file)
pkl_file.close()


def recon(account,cost_amount,expense_type):
     # re-open the data file with wb mode
     pkl_file = open('account.pkl','wb')
     old_position = account_list[account][2]
     if old_position < cost_amount:
	print 'no enough money !'
	sys.exit()
     else:
	
	global intrest
	intrest = 0
	if expense_type == 'Withdraw':

		intrest = cost_amount * 0.05
		new_position = old_position - cost_amount - intrest 
	else:
		
		new_position = old_position - cost_amount

	account_list[account][2] = new_position
	print new_position
	pickle.dump(account_list,pkl_file) # change the account new amount and dump it into file
	pkl_file.close()

print account_list


recon('8908223631',2000,'Withdraw')
logger.record_log('8908223631',2000,'Withdraw',intrest)
