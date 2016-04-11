#!/usr/bin/env python
#-*- coding: utf-8 -*-
class ITdiaosi:
	def __init__(self,name,Age,sex,educational_background,specialty,work_Experience):
		self.name = name
		self.age = Age
		self.sex = sex
		self.educational_background = educational_background
		self.specialty = specialty
		self.work_Experience = work_Experience
	def information(self):
		print '''
==============================================================================个人信息================================================================================
			 my name is %s,
			 i'm %s years old,
			 i'm %s,
			 my educational_background is %s,
			 my specialty is %s,
			 i have work %s years''' %(self.name,self.age,self.sex,self.educational_background,self.specialty,self.work_Experience)
class HRdemand(ITdiaosi):
	def __init__(self,salary_requirements,name,age,sex,educational_background,specialty,work_Experience):
		ITdiaosi.__init__(self,name,age,sex,educational_background,specialty,work_Experience)
		self.salary = int(salary_requirements)
	def needed(self):
		print '''
===============================================================================面试要求对比===========================================================================
			Our salary_requirements is %s,
			your name is %s,
			our age requirements is elder than 19,your age is %s,
			our sex requirements is male,your sex is %s,
			our educational_background requirements is higher or equal university,your educational_background is %s,
			our specialty is not serious requirements and your specialty is %s,it's very good
			our work_Experience requirements is older than one year,and your work_Experience is %s ,it's longer than our requirements''' %(self.salary,self.name,self.age,self.sex,self.educational_background,self.specialty,self.work_Experience)	

class offer:
	def __init__(self,salary,date,address,probationary_period):
		self.salary = salary
		self.date = date
		self.address = address
		self.probationary_period = probationary_period
	def hello(self):
		print '''
============================================congratulation============================================================================================================
		      Hi,dear,congratulations,you have pass the audition.
		      your salary will be %s,
		      your first day of work will be %s,
		      the address of company is %s,
		      the probationary_period will take %s month''' %(self.salary,self.date,self.address,self.probationary_period)
P = ITdiaosi('zhangsan',20,'male','university diploma','it',2)
P.information()
P1 = HRdemand(10000,'zhangsan',20,'male','university diploma','it',2)
P1.needed()
P2 = offer(10000,'0526','beij','3')
P2.hello()
