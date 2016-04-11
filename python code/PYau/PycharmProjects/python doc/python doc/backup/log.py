#!/usr/bin/env python
# -*- coding:utf_8 -*-
'''
author : Cheney Hsu
last update : 2014/06
'''
import time

logfile = '/tmp/backup'

def record_log(Backup_type,Status,files,description = 'NULL'):
    date = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
    record_line = "%s    %s    %s    %s    %s\n" %(date,Backup_type,Status,files,description,)
    f = file('logfile','a')
    f.write(record_line)
    f.flush()
    f.close()

