#!/usr/bin/env python

#Return system Date
def NOWTIME():
    from datetime import date
    import time 
    now = date.today()
    return now.strftime("%Y%m%d")+time.strftime('%H')
#    return now.strftime("%Y%b%d")

#Return filename of Check Resule
def FILE():
    import os,commands
    ID = commands.getoutput('grep HXSERVERID /etc/profile | awk -F \"=\" \'{print $2}\'')
    if os.path.exists('/tmp/report/'):
        FN = '/tmp/report/'+ID+'.'+NOWTIME()+'.html'
        return FN
    else:
        os.system('mkdir -p /tmp/report')
        FN = '/tmp/report/'+ID+'.'+NOWTIME()+'.html'
        return FN
def FILEDIFF():
    import os,commands
    ID = commands.getoutput('grep HXSERVERID /etc/profile | awk -F \"=\" \'{print $2}\'')
    if os.path.exists('/tmp/report/'):
        FN = '/tmp/report/'+ID+'.'+'DIFF'+'.'+NOWTIME()+'.html'
        return FN
    else:
        os.system('mkdir -p /tmp/report')
        FN = '/tmp/report/'+ID+'.'+'DIFF'+'.'+NOWTIME()+'.html'
        return FN
