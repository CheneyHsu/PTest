#!/usr/bin/env python
# -*- coding:utf_8 -*-

import os,time

a = [0,1,2,3,4,5,6,7,8,9]
9 in a 

'''
AttibuteError    试图访问的一个对象没有的属性,例如foo.x,访问的时候没有x
IOError     输入/输出异常;基本上无法打开文件
ImportError 无法引入模块或包,基本上是路径问题或者名称错误
IndentationError  语法错误(的子类);代码没有正确对齐
IndexError 下标索引超出序列边界,比如当X只有三个元素,却试图访问X[5]
KeyError   试图访问字典内不存在的键
KeyboardInterrupt Ctrl+C被按下
NameError   使用一个还未被赋予对象的变量
SyntaxError  Python代码非法,代码不能编译(语法错误)
TypeError  传入对象类型与要求的不符合
UnboundLocalError   试图访问一个还未被设置的局部变量,基本上是由于另有一同名的全局变量,导致
                            你以为正在访问它.
ValueError       传入一个调用者不希望的值,即使值的类型是正确的.
'''
#keyerror 错误示例

dic = {'id': '0001' , 'name':'clx'}
dic['name']
try:
    dic['age']
except KeyError:
        print "No this value found!"


#os.system('for i in {1..100};do sleep 1 ; echo "Number $i";done')

'''
for i in range(1,101):
    try:
        print 'Number %s' % i
        time.sleep(0.5)
    except KeyboardInterrupt:
        print 'Pls do not interrupt me , I am doing the important task here!'
        continue
 '''  
''' 
dict = {0:0,1:1,2:2,3:3,4:4,5:5,6:6}
input = int(raw_input('Pls input number:'))
for num in range(input):
    try:
        print"number %s" % dict[num]
        time.sleep(0.5)
    except KeyboardInterrupt:
        print "do not input ctrl + c"
    except KeyError:
        print '%s not exits' % num
        continue
   '''
'''
class MyException(Exception):
    pass

try:
    list = ['Alex','Rain','Redhat'] 
    raise MyException

except MyExcetion:
    print"MyException encoutered"
    
    
#Try.....finally (无论try块是否抛出异常,永远执行代码,通常用来关闭文件,断开服务器连接等功能)    
'''
    
class MyException(Exception):
    pass

try:
    raise MyException,",and some additional data" 
except MyException,data:
    print"MyException encotered"
    print data     
