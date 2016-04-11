#!/usr/bin/env python
import sys
class Person:
	count=1
	def __init__(self,name,age,sex,job="none",salary="none",com="anonymous",lover="",experience=0,skill="linux",money=10000):
		self.name=name
		self.age=age
		self.sex=sex
		self.job=job
		self.salary=salary
		self.com=com
		self.lover=lover
		self.experience=experience
		self.skill=skill
		self.have_money=money
	def personal_information(self):
		print """\033[31;1m
Name: %s
Age: %s
Sex: %s
Job: %s
Salary: %s
experience: %s
skill:%s
Total_Money: %s \033[0m
"""%(self.name,self.age,self.sex,self.job,self.salary,self.experience,self.skill,self.have_money)

	def sayHi(self):
		status=self.rich_or_poor()
		print "hello %s,now you are \033[32m%s\033[0m"%(self.name,status)
	def rich_or_poor(self):
		if int(self.salary) >13000:
			if self.sex=="m":
				return "GaoFuShuai"
			else:return "BaiFuMei"
		else:return "QiongDiaoSi"
	def todolist(self):
		print """
To do list

1 work 

2 love

3 job-hunting

4 personal information 
"""	
		rs=input("Enter your choice:")
		return rs
class Love:
	def __init__(self,p):
		if p.lover=="":
			p.lover=raw_input("enter your lover:")	
	def canLove(self,p):
		if p.salary <13000 :
			print "\033[32myou are so poor,can not love,salary must reach to 13000 \033[0m"
			return False
		elif p.age<18:
			print "\033[32myou are too small,can not love\033[0m"
		else:
			return True
	def have_dinner(self,p):
		print "\033[31;1myou and %s have a good dinner tonight\033[0m"%p.lover
		p.have_money-=200
	def go_to_movies(self,p):
		print "\033[31;1mThe film is very nice...\033[0m"
		p.have_money-=200		
	def get_married(self,p):
		if p.have_money<600000:
			print "\033[31;1myou are too poor,can not get married,save money to 600000\033[0m"
		else:
			print "\033[31mCongratulations! Game over!\033[0m"
			sys.exit(1)
		
class Company:
	def __init__(self,name="anonymous",need_skill="linux",need_experience=0,salary=5000,growing=""):
		self.name=name
		self.need_skill=need_skill
		self.need_experience=need_experience
		self.salary=salary
		self.growing=growing
	def interview (self,p):
		if p.com==self.name:
			print "\033[31mno need interview ,you are working in %s\033[0m"%p.com
			return False
		if p.experience >=self.need_experience and self.need_skill in p.skill:
			print "\033[31;1mCongratulation,You are hired\033[0m"
			p.experience=0
			p.com=self.name
			return True	
		else:
			print "\033[32mSorry,try again next time.requeset %s skill and %s ralation experience\033[0m"%(self.need_skill,self.need_experience)
			return False
	def start_work(self,p):
		p.salary=self.salary
		time=int(raw_input("How long to work?[mouth]"))
		p.have_money+=p.salary*time
		p.experience+=time
		if p.experience >=12:
			if self.growing!="":
				p.skill+=" "+self.growing
	
	
def create_character():
	print "Create youre personal information:"
	print "\033[31;0mI knew you are a IT administrator\033[0m"
	job="IT"
	while True:
		name=raw_input("What is your name:")
		if name!="":
			break
	while True:
		age=input("what is your age:")
		if age>0:
			break
	while True:
		sex=raw_input("what is your sex:[m/f]")
		if sex!="":
			break
	while True:
		salary=input("what is your salary:")
		if salary>0:
			break
	return name,age,sex,job,salary
def love_list():
	print """
1 have dinner        cost 200RMB
2 go to the movies   cost 200RMB
3 get married        cost 600000RMB 
4 return
"""
def com_list():
	print """
1 taobao
2 yahoo
3 google
"""
#main entry

print """
Welcome to The  Sims !
"""
try:	
	name,age,sex,job,salary=create_character()
	p=Person(name,age,sex,job,salary)
	com=Company(salary=p.salary)	
	p.sayHi()
	while True:
		rs=p.todolist()
		print rs
		if rs==1:
			com.start_work(p)
			print "Now you have %s RMB"%p.have_money
		elif rs==2:
			l=Love(p)
			if l.canLove(p):
				while True:
					love_list()
					rs=input("Enter your choice:")
					if rs==1:
						l.have_dinner(p)
					elif rs==2:
						l.go_to_movies(p)
					elif rs==3:
						l.get_married(p)
					elif rs==4:
						break
		elif rs==3:
			com_list()
			num=input("Enter the commpany number:[1 2 3]")
			if num==1:
				c=Company("taobao","linux",12,12000,"mysql")
				if c.interview(p):
					com=c
			elif num==2:
				c=Company("yahoo","linux mysql",12,16000,"python")
				if c.interview(p):
					com=c
			elif num==3:
				c=Company("google","linux mysql python",12,20000,"php")
				if c.interview(p):
					com=c
		elif rs==4:
			p.personal_information()		

except KeyboardInterrupt:
	sys.exit(11)


except Exception,e:
	print e


