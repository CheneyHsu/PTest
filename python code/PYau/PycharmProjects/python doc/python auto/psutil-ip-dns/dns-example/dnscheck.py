#!/usr/bin/env python
#-*- coding:utf-8 -*-
# Filename:    dns example
# Revision:    1.0
### END INIT INFO

import dns.resolver
import os
import httplib

#定义业务名称和IP地址变量列表
iplist=[]
appdomain="www.baidu.com"

#域名解析函数，成功可追加到iplist
def get_iplist(domain=""):
	try:
		A=dns.resolver.query(domain,'A')
	except Exception,e:
		print "dns resolver error:"+str(e)
		return
	for i in A.response.answer:
		for j in i.items:
			iplist.append(j.address)
	return

def checkip(ip):
	checkurl=ip+":80"
	gehtcontent=""
	httplib.socket.setdefaulttimeout(5)  #超时5秒
	conn=httplib.HTTPConnection(checkurl)  #创建HTTP链接对象
	
	try:
		conn.request("GET", "/",headers = {"Host": appdomain})  #发起链接，添加host主机头
		
		r.conn.getresponse()
		getcontent = r.read(15) #获取页面前15个字符，用于比对 
	finally:
		if getcontent=="<!doctype html>":  #监控页面内容，可以事先定义好，例如http 200错误。
			print ip+"[ Ok ]"
		else:
			print ip+"[ Error ]"   #可以放置警告程序，可以使邮件和短信
			
if __name__=="__main__":   #域名解析正确最少返回一个函数。
	if get_iplist(appdomain) and len(iplist) > 0:
		for ip in iplist:
			check(ip)
	else:
		print "dns resolver error."