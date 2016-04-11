#!/usr/bin/env python

import pickle
account_info = {'8094661':['redhat',15000,15000],
		'8094651':['test',9000,9000],
		}

f = file('account.pkl','wb')
pickle.dump(account_info,f)

f.close()
