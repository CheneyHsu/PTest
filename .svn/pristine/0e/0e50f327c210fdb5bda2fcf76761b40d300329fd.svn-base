#!/usr/bin/env python
#-*- coding:utf-8 -*-
__author__ = 'KK'
import SocketServer
import os
#如果使用这个类,就必须有一个 handel 的函数

class MyTCPhandler(SocketServer.BaseRequestHandler):

    #handel 处理所有请求和操作.
        def handle(self):
            print "got connection from: ", self.client_address
            #strip 去掉空格
            while 1:
                self.data = self.request.recv(4096)
                if not self.data:continue
                #地址打印出来,客户端IP.
    #            print"{}wrote:".format(self.client_address[0])
                print "will run this on server:", self.data
                cmd = os.popen(self.data)
                result = cmd.read()
                format_data="\033[32;1m %s \033[0m" % self.data
                #原 data 数据进行 send
                self.request.sendall(result)


#__main__ 是本程序,如果这个程序是本机运行.而不是调用,那么就执行.
#如果被调用,那么下面代码将不被执行.

if __name__=="__main__":
    HOST,PORT="localhost",9990
    #Create the server , Binding to localhost on port 9999
    #单线程
#    server=SocketServer.TCPServer((HOST,PORT),MyTCPhandler)
    #多线程
    server=SocketServer.ThreadingTCPServer((HOST,PORT),MyTCPhandler)
    #Acticeate the server; this will keep running until you
    #interrupt the program with Ctrl-C
    server.serve_forever()

'''
h,p = '',9999
server = SocketServer.TCPServer((h,p),MyTCPhandler)
server.serve_forever()
'''
