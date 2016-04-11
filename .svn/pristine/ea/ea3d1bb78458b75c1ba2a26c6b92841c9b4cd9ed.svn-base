#!/usr/bin/env python


logfile=file('logfile','a')
while True:
	message1=raw_input("Pls input your messages:\n")
	message=message1+'\n'
	#print message
	logfile.write(message)
	logfile.flush()
	if message1 == 'exit':
		logfile.close()
		break


