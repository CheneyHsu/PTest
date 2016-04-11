#!/usr/bin/env python
import pickle

userinfo = open("userinfo","r")
while True:
    try:
        line = pickle.load(userinfo)
        print line
    except:
        break
