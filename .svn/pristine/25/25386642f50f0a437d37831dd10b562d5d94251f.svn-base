#!/usr/bin/env python
import sys
import datetime

class Company:
	def __init__(self,company_name,pay_day):
		self.company = company_name
		self.pay_day = pay_day
	def create_introduce(self):
		if self.company == 'taobao':
			self.company_intro = "\033[32mTaobao is a well known B2C company and is willing to hire excellent IT engineer like you!\033[0m"
		elif self.company == 'sina':
			self.company_intro = "\033[32mSina.com is a portals web providor, we also have the biggest weibo in China, working in Sina will make you a big future!\033[0m"
		elif self.company == 'baidu':
			self.company_intro = "\033[32mBaidu is the biggest search providor in China!\033[0m"
		else:
			print "can not find the company information, please check!"
	def print_company_info(self):	
		print self.company_intro

class HR(Company):
	def __init__(self,company_name,pay_day,salary_range):
		Company.__init__(self,company_name,pay_day)	
		salary_range = salary_range.split('-')
		for y in range(2):
			salary_range[y] = int(salary_range[y])
		self.salary = salary_range
#		print self.salary
	def check_hire(self,hire_require):
		self.hire_require = hire_require
		self.hire_lst = []
		self.require = []
		self.hire_lst = self.hire_require.split(',')	 
		all_require = ['Linux','Shell','Mysql','Oracle','VMware','Python','Perl','network','Storage']
		for i in range(len(self.hire_lst)):
			if self.hire_lst[i] == '1':
				self.require.append(all_require[i])
		
		return self.require
	def salary_discuss(self,salary_want):
		self.want = salary_want
		if self.want <= self.salary[1]:
			print "This is OK!"
		else:
			decision = raw_input("Your require is out of our range. How about %s? y/n ?"%self.salary[1])
			if decision == 'y':
				print "Great, Welcome to join our company!"
				self.want = self.salary[1]
			else:
				print "Sorry, we can not offer you this position."
				sys.exit()		
	def first_day(self):
		datecheck = datetime.datetime.now()
		date_onboard = datecheck + datetime.timedelta(days = 30)
		print "Today is %s"%(datecheck.strftime("%y-%m-%d"))
		decision = raw_input("We will give you 1 month to finish your work in your last company. Your first work day will be %s . is that OK ? y/n ?"%date_onboard.strftime("%y-%m-%d"))
		if decision == 'y':
			print "Great! You can get your salary on the %s th every month, So this is the deal! See you next month"%self.pay_day
		else:
			while True:
				new_decision = raw_input("K, how many days do you need ?")
				try:
					new_decision = int(new_decision)
					date_onboard = datecheck + datetime.timedelta(days = new_decision)
					print "OK, So your first day will be %s, you can get your salary on the %s th every month"%(date_onboard.strftime("%y-%m-%d"),self.pay_day) 
					print "Welcome to our company! See you in %s days"%new_decision
					return date_onboard
				except:
					print "wrong input"			
				
class Audition(HR):
	def __init__(self,company_name,pay_day,salary_range):	
		HR.__init__(self,company_name,pay_day,salary_range)
	def check_qualify(self,name,skills,requires):
		self.name = name
		self.skills = self.check_hire(skills)
		self.require = self.check_hire(requires)
		msg = ','.join(self.skills)
		print "Please introduce yourself."
		print "My name is %s, I have learned %s"%(self.name,msg)
		qualify = 0
		all_require = 0
		for i in self.require:
			if i in self.skills:
				qualify += 1
			all_require += 1
		if (all_require)/(qualify) <= 1 and (all_require)%(qualify) < 3:
			print "You are qualified!"
			want = int(raw_input("Please input how much salary you need for a month: "))
			self.salary_discuss(want)
			self.first_day()
		else:
			print "Sorry, you can not reach our require."
			sys.exit()
			
hr1 = Audition('taobao','30','12000-15000')
hr1.create_introduce()
hr1.print_company_info()
hr1.check_qualify('jerry ji','1,0,1,1,1,0,0,1,0','1,0,1,1,1,1,0,1,0')



