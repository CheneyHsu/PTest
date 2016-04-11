#!/usr/bin/env python
import sys,os
import datetime
#import hire1
import pickle

################################################
#person in the relations:
#	HanMeimei girl pretty and good job
#	LiLei	boy don't have good job
#	Jim	boy good job and rich
#	Lucy	girl secritary of Jim		
################################################

class Person:
        def __init__(self,name,sex,job,salary,properties):
                self.name = name
                self.sex = sex
                self.job = job
		self.salary = salary
		self.properties = properties
		self.info = [self.name,self.sex,self.job,self.salary,self.properties]
	
	def selfrespect(self):
		if self.salary > 14000 and self.properties > 100000:
                        if self.sex == 'man':
                                self.called = 'High_Rich_Handsome'
                        else:
                                self.called = 'White_Rich_Pretty'
                else:
                       	self.called = 'Loser'
		print "My name is %s, I work as a %s, You can call me a %s"%(self.name,self.job,self.called)
	
class Relations(Person):
	def __init__(self,name,sex,job,salary,properties):
		Person.__init__(self,name,sex,job,salary,properties)
		
	def picklefile_load(self,filename):
		if os.path.exists(filename):
			f = open(filename,'r')
			self.relations = pickle.load(f)
			f.close()
		else:
			f = file('love.txt','w+')
			self.relations = {'HanMeimei':{'LiLei':9,'info':['HanMeimei','woman','Auditor',14000,100000]},'LiLei':{'HanMeimei':10,'info':['LiLei','man','IT',5000,500]},'Jim':{'HanMeimei':7,'info':['Jim','man','Senior Manager',24000,1000000]},'Lucy':{'Jim':9,'info':['Lucy','woman','Secritary',4000,1000]}}
			pickle.dump(self.relations,f)
			f.close()

	def picklefile_dump(self,filename):
		f = open(filename,'w+')
		pickle.dump(self.relations,f)
		f.close()
			
	def relationship(self,person_relate,score,just):
		relations = self.relations
		sex_relate = []
		if self.sex == 'man':
			for i in relations:
				if relations[i]['info'][1] == 'woman':
					sex_relate.append(i)
		else:
			for i in relations:
				 if relations[i]['info'][1] == 'man':
                                        sex_relate.append(i)
		print "Below person will judge your behave.",sex_relate
		try:
			sex_relate.remove(person_relate)
		except:
			print "\033[35mAre you gay? I have to stop this!\033[0m"
			sys.exit()
		if person_relate not in relations[self.name].keys():
			relations[self.name][person_relate] = 0
		if just == 'add':
			relations[self.name][person_relate] += score
			for x in sex_relate:
				try:
					relations[self.name][x] -= score
				except:
					relations[self.name][x] = 0
		else:
			relations[self.name][person_relate] -= score	
				
	def active(self):
		self.picklefile_load('love.txt')
		relations = self.relations
		relations[self.name]['info'] = self.info
		check_person_relate = 0
		current_relate = []
		for i in relations:
			if i != self.name and 'info' in relations[i]:
				print "Found relations with %s."%i
				current_relate.append(i)
		if current_relate == None:
			print "Can not find anyone relate!"
			sys.exit()
		check_active = 0
		while check_active != 2:
			choice_person = raw_input("Which one do your wants to get relations with: ")
			if choice_person in relations:
				check_active += 1
				person_relate = choice_person
			else:
				print "Can not find person."
				continue
			print "1. Buy flowers 2. Buy purse/bags 3. Take a walk 4. Buy a car"
			print "5. flirt \t 6.treat for meal 7.flirt with others"
			active_list = {1:[1,'add',100],2:[2,'add',2000],3:[1,'add',0],4:[5,'add',100000],5:[1,'add',20],6:[1,'add',100],7:[7,'reduce',20]}
			try:
				choice_active = int(raw_input("Your choice : "))
				check_active += 1
			except:
				print "\033[31mWrong input! Try again\033[0m"
			if self.properties > active_list[choice_active][2]:
				self.relationship(choice_person,active_list[choice_active][0],active_list[choice_active][1])
			else:
				print "You do not have money to do that!"
				check_active -= 1

class Love(Relations):
	def __init__(self,name,sex,job,salary,properties):
		Relations.__init__(self,name,sex,job,salary,properties)
	def annonce(self):
		self.picklefile_load('love.txt')
		love_dic = {}
		for i in self.relations:
			for x in self.relations[i]:
				if x != 'info':
					if self.relations[i][x] >= 9:
						print "%s love %s !"%(i,x)
						love_dic[i] = x
		already_check = []
		for a in love_dic:
			try:
				if a not in already_check and love_dic[love_dic[a]] == a:
					print "%s and %s are in love!" %(a,love_dic[a])
					already_check.append(love_dic[a]) 					
			except:
				continue

hmm = Love('HanMeimei','woman','Audit',10000,120000)
hmm.active()
hmm.annonce()														
