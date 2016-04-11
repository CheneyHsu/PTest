#!/usr/bin/env python


def testftpip():
	import os

	ips=open('/usr/report/ftpip','r')
	ip_True=open('/usr/report/ftpiptrue','rw+')
	ip_False=open('/usr/report/ftpipFalse','w+')
	iptest=open('/usr/report/ftpiptrue','r').read()
	if len(iptest)==0:
		for i in ips.readlines():
			ip = i.replace('\n','')
			return1=os.system('ping -c 2 %s' %ip)
			if return1:
				ip_False.write(ip+'\n')
			else:
				ip_True.write(ip+'\n')
				return ip
				break
	else:
		for i in ip_True.readlines():
			ip = i.replace('\n','')
			return1=os.system('ping -c 2 %s' %ip)
			if return1:
				ip_True.close()
				ip_True=open('/usr/report/ftpiptrue','w')
				for i in ips.readlines():
		                        ip = i.replace('\n','')
                		        return1=os.system('ping -c 2 %s' %ip)
                        	if return1:
                                	ip_False.write(ip+'\n')
                        	else:
                                	ip_True.write(ip+'\n')
                                	return ip
                                	break

			else:
				return ip
	iptest.close()
	ip_True.close()
	ip_False.close()
	ips.close()	
testftpip()
