#!/usr/bin/env python

#pickle.dump(userInfo,open("userinfo",'wb'))
#userinfo = { '111':['123','15000','15000'],
#	      '222':['456','8000','8000'],
#	      '333':['789','3000','3000'],	
#	 	 }
#pickle.dump(userInfo,open("userinfo","rb+"))

userInfo = pickle.load(open("userinfo","rb"))
while True:
	accountAuth = raw_input("Pls input user \033[33;1maccount\033[0m:").strip()
	if len(accountAuth) == 0 :continue
	if userInfo.has_key(accountAuth):
		if 'lock' in userInfo[AccountAuth]:
			print "%r user has been locked, Plese unlock" % accountAuth
			exit()
		for num in range(3,0,-1)
			passwdAuth = raw_input("Pls input user \033[33;1mpassword \033[0m:").strip()
			if len(passwdAuth) == 0: continue
			if passwdAuth = userInfo[accountAuth][0]:
				list()
			else:
				print "Wrong password,Can try again %r items" %num
				continue
