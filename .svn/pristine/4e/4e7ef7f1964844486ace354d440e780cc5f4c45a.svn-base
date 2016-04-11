#!/usr/bin/env python

class Person:
	def __init__(self,name,age,sex,occupation,city,asset=10000):
		self.Name = name
		self.Age = age
		self.Sex = sex
		self.Job = occupation
		self.City = city
		self.Asset =  asset
	
	def tell(self):
		info = """ 
		\nHello, my name is %s, I am %s years old, nice to meet you, I am a %s,work in %s , how about you!

		""" % (self.Name,self.Age,self.Job,self.City) 
		print info
		print self.Asset

class Love(Person):
	def __init__(self,name,age,sex,occupation,city,asset=10):
		Person.__init__(self,name,age,sex,occupation,city,asset=1000)

	def action(self,action_type):
		print action_type
		if action_type == 'FirstMet':
			self.tell()
		if action_type == "Match=50":
			print 'Bey bey , do not like each other'
			return 50
		if action_type =='WatchMovie':
			pass			
R = Love('Oldboy','26','Male','Advanced System Enginner','Bejing')
p = Love('BigBrother','36','Male','Advanced System Enginner','Bejing')	
#p.tell()	
p.action('FirstMet')
if p.action('Match=50') == 50:
	print 'sorry ,you are good but not suitable for me!'
	print 'Met R'
	R.action('FirstMet')
#P = Person('BigBrother','36','Male','Advanced System Enginner','Bejing')
#P.tell()
#P.tel
