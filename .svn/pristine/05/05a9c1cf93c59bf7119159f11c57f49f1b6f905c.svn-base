#!/usr/bin/env python
# -*- coding:utf-8 -*-
# 许成林
# 2014-10->2014-11
# Version 1.0
# Handing Check And Fix
##############################################################
import os
import time
import sys
import commands


commentlines = []
c = file('/usr/report/comment')
for line in c.readlines():
    c_line = line.splitlines()
    commentlines.extend(c_line)
commandlines = []
d = file('./command')
for line in d.readlines():
    d_line = line.splitlines()
    commandlines.extend(d_line)


def MAIN():
    HT()
    HTCOM()
    COMMAND()


def HTCOM():
    FILENAME = FILE()
    x = 0
    y = 0
    os.system("echo '<table style=\"TABLE-LAYOUT: fixed\" border=0 cellspacing=10 cellpadding=0>'>>" + FILENAME)
    os.system("echo '<tr>'>>"+FILENAME)
    while x < 53:
        if x%10==0:
            os.system("echo '</tr>'>>"+FILENAME)
            os.system("echo '<tr>'>>"+FILENAME)
        os.system("echo '<td valign=top>'>>"+FILENAME)
        os.system("echo '<p><a href=#" +commentlines[x]+ ">" +commentlines[x]+ "</a></p>'>>" + FILENAME)
        x = x + 1
    os.system("echo '</td></tr></table>'>>"+FILENAME)
    os.system("echo '<hr size=2 width=100% color=#ff0000>'>>" + FILENAME)



def COMMAND():
    FILENAME = FILE()
    x = 0
    while x < 53:
        os.system("echo '<a name=" + commentlines[x] + "></b></H2>'>>" + FILENAME)
        os.system("echo '<H2><b>" + commentlines[x] + "</H2></b><p>'>>" + FILENAME)
        os.system("echo '<font size=4><xmp>'>>" + FILENAME)
        os.system(commandlines[x] + ">>" + FILENAME)
        os.system("echo '</xmp></font>'>>" + FILENAME)
        x = x + 1
        os.system("echo '</i></font><a href=\"#top\">返回页首</a>'>>" + FILENAME)
        os.system("echo '<hr size=2 width=100% color=#ff0000>'>>" + FILENAME)

#Return system Date
def NOWTIME():
    from datetime import date
    import time
    now = date.today()
#    return now.strftime("%Y%b%d")+"_"+time.strftime('%H%M%S')
    return now.strftime("%Y%b%d")

#Return filename of Check Resule
def FILE():
    import os
    if os.path.exists('/tmp/OS_CHECK'):
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN
    else:
        os.system('mkdir -p /tmp/OS_CHECK')
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN



MAIN()