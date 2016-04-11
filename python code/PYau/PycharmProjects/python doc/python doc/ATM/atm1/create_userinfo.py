#!/usr/bin/env python
import pickle
import fileinput
userInfo = {'111':['123','15000','15000'],
            '222':['456','8000','8000'],
            '333':['789','3000','3000']
            }
#pickle.dump((user1,user2,user3),open("userinfo","a"))
pickle.dump(userInfo,open("userinfo","w"))

userinfo = open("userinfo","r")
while True:
    try:
        line = pickle.load(userinfo)
        print line
    except:
        break
