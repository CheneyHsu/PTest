#!/usr/bin/python
import pickle
import sys


def initial_account():
	Account = {}
	#user_info:
	#Account,password,credit,balance,last_month_bill,consume_this_month,check_minimum_repay
	user_info1 = ['12345678','1234',15000,15000,0,0,0]
	user_info2 = ['87654321','4321',8000,8000,0,0,0]
	Account['12345678'] = user_info1
	Account['87654321'] = user_info2
	Account['Last_date'] = [1,1]
	save_file(Account,0)
	Account = load_file(0)
	return Account

#User login
def user_login():
	login_check = 0
	while login_check != 1:
		user = raw_input("Please input your account Number: ")
		if user == '': continue
		user = user.strip()
		if len(user) == 8 and user in Account.keys():
			password = raw_input("Please input your password: ")
			if password == Account.get(user)[1]:
				login_check = 1
				print "Welcome %s".center(40,' ') %user
				return user
			else: print "Wrong password,please login again!"
		else: print "Wrong account number,please login again!"
			

#file operation
def loger(account,tran_date,tran_type,amount,interest):
	logfile = 'credit_account.log'
	f = file(logfile,'a')
	msg = "%s %s %s %s %s\n"%(account,tran_date,tran_type,amount,interest)
	f.write(msg)
	f.close()

def load_file(check_history_file):
	if check_history_file == 0:
		f = open('account.log','r')
		Account = pickle.load(f)
		f.close()
		return Account
	else:
		f = open('account_history.log','r')
		Account_history = pickle.load(f)
		f.close()
		return Account_history

def save_file(Account,check_history_file):
	if check_history_file == 0:
		f = open('account.log','w')
		pickle.dump(Account,f)
		f.close()
	else:
		f = open('account_history.log','w')
		pickle.dump(Account,f)
		f.close()

# Ask user input date,form it and check if it's time traveller.
def CheckDate(Last_date):
	check_date = 0
	check_new_month = 0
	while check_date != 1:
		Date = raw_input("Please input current date, form: MM-DD: ")
		if Date == '':
			continue
		try:
			Date = Date.strip().split('-')
			for i in range(2):
				Date[i] = int(Date[i])
			print Date
			#print Last_date
			if Date[0] >= Last_date[0]: # and Date[1] >= Last_date[1]:
				#print "making new date"
				if Date[0] - Last_date[0] > 0:
					check_new_month = 1
				Last_date = Date
				check_date = 1
			elif Date[1] >=Last_date[1]:
				Last_date = Date
			else: print "No time traveller"
		except:
			print "Wrong input, please reinput with the correct form!"
	return Last_date,check_new_month




def number_choice():
	check_choice = 0
	while check_choice != 1:
                choice = raw_input("Please choose : ")
                if choice == '':continue
                try:
                        choice = choice.strip()
                        choice = int(choice)
                        if choice >0 and choice <7:
                                check_choice =1
                                return choice
                        else: print "Wrong Number, please input again"
                except:
                        print "Please input a valid number"


def input_money():
	#print "Please insert money: "
	check_money = 0
	while check_money != 1:
		Money = raw_input("Please insert money: ")
		if Money == '':continue
		Money = Money.strip()
		try:
			Money = int(Money)
		except:
			print "invalid Number!"
			continue
		check_money = 1
		return Money
		

def shopping(user_info):
	check_shopping = 0
	while check_shopping != 1:
		print "\033[34mCoffee\t\t$35 \033[0m"
		print "\033[34mshoes\t\t$500 \033[0m"
		print "\033[34miphone4\t\t$3200 \033[0m"
		print "\033[34mPC\t\t$6500 \033[0m"
		print "\033[34mpen\t\t$10 \033[0m"
		print "\033[34mMAC Air \t$12000\033[0m"
		print "\033[34mExit\033[0m"
		shop_choice = raw_input("please input your choice: ")	
		shop_list = { 'coffee':35,'pen':10, 'shoes':500, 'iphone4':3200, 'pc':6500, 'mac air':12000 }
		if shop_choice == '': continue
		shop_choice = shop_choice.strip()
		shop_choice = shop_choice.lower()
		if shop_choice in shop_list.keys():
			if user_info[3] >= shop_list.get(shop_choice):
				user_info[3] = user_info[3] - shop_list.get(shop_choice)
				user_info[5] += shop_list.get(shop_choice)
				Account[user] = user_info
				save_file(Account,0)
				loger(user,log_date,shop_choice,shop_list.get(shop_choice),0)
			else:
				if user_info[3] < 10:
					print "\033[31mYou do not have any balance, please repay your bill!\033[0m"
					check_shopping = 1
					break
				print "you do not have enough money to buy %s,please change another one" %shop_choice
		elif shop_choice == 'exit':
			print "see you next time!"
			check_shopping = 1
		else:
			print "No item found! please input again!"		
		print_account(user_info)
	

def leave_screen():
	while True:
		leave = raw_input("leave this screen(y/n)?: ")
		if leave == '':continue
		leave = leave.strip().lower()
		if leave ==  'y':
			return 1
			break
		elif leave == 'n':
			return 0
			break
		else:
			print "wrong input!"



def cashin(user_info):
	while leave_screen() !=1:
		cashin_money = input_money()
		cashin_money_interest = cashin_money * 0.05
		if (cashin_money + cashin_money_interest) >= user_info[3]:
			print "Do not have enough money!"
		else:
			user_info[3] = user_info[3] - cashin_money -cashin_money_interest
			user_info[5] += (cashin_money + cashin_money_interest)
			Account[user] = user_info
			save_file(Account,0)
                        loger(user,log_date,'CashIn',cashin_money,cashin_money_interest)	
		print_account(user_info)		

def Repayment(user_info):
	while leave_screen() != 1:
		repay_money = input_money()
		repay_show = repay_money - (repay_money * 2)
		if user_info[4] == 0:
			user_info[3] += repay_money
			if repay_money >= user_info[5]:
                        	user_info[5] = 0
               		else: user_info[5] = user_info[5] - repay_money
			Account[user] = user_info
			save_file(Account,0)
			loger(user,log_date,'Repay',repay_show,0)
		else:
			if user_info[4]  >= repay_money:
				if (user_info[4] * 0.1) >= repay_money:
					user_info[6] = 1
				else: user_info[6] = 0
				user_info[4] = user_info[4] - repay_money
				user_info[3] += repay_money
				Account[user] = user_info
				save_file(Account,0)
				loger(user,log_date,'Repay',repay_show,0)
			else:
				left_repay_money = repay_money - user_info[4]
				user_info[4] = 0
				user_info[6] = 0
				user_info[3] += repay_money
				if left_repay_money >= user_info[5]:
					user_info[5] = 0
				else: user_info[5] = user_info[5] - left_repay_money
				Account[user] = user_info
				save_file(Account,0)
				loger(user,log_date,'Repay',repay_show,0)
				
		print_account(user_info)


def change_password(user_info):
	while True:
		new_password = raw_input("please input your new password:")
		if new_password == '':continue
		new_password2 = raw_input("please input your new password again:")
		if new_password2 == '': continue
		if new_password.strip() == new_password2.strip():
			new_password = new_password.strip()
			user_info[1] = new_password
			Account[user] = user_info
			save_file(Account,0)
			loger(user,log_date,'Change pw',0,0)
			break
		else: print "Wrong input!"
	

def print_account(user_info):
	print "\033[36mAccount: %s,credit: %s,balance: %.2f,minimum_repay is: %.2f\033[0m"%(user_info[0],user_info[2],user_info[3],user_info[4])			

def print_bill(user_info):
	print "History bill".center(60,'-')
	print "\033[35mAccount\t\tCredit\tBalance\t\tMinimum repay this month\033[0m"
	print "\033[35m%s\t%d\t%.2f\t\t%.2f\033[0m"%(user_info[0],user_info[2],user_info[3],(user_info[4] * 0.1))
	print "Tranaction log for this month".center(60,'-')
	print "\033[34mAccount\t\tDate\t\ttran_type\tmount\tinterest\033[0m"
	logfile = 'credit_account.log'
	try:
		f = file(logfile,'r')
	except:
		print "No file exist!"
		return None
	#msg = "%s %s %s %s %s\n"%(account,tran_date,tran_type,amount,interest)
	for i in f.readlines():
		i=i.split()
		i_date = i[1].split('-')
		for x in range(2):
			i_date[x] = int(i_date[x])
		if i_date[0] == date[0] and i[0] == user:
			#print "printing"
			i_formdate = '2013'+ '/' + str(i_date[0]) + '/' + str(i_date[1])
			print "\033[34m%s\t%s\t%s\t\t%s\t%s\033[0m"%(i[0],i_formdate,i[2],i[3],i[4])		
	f.close()
	print "End".center(60,'-')

#initialize date
try:
	Account = load_file(0)
	try:
		Account_history = load_file(1)
	except:
		Account_history = {}
		for x in Account.keys():
			Account_history[x] = {}
	#print Account['Last_date']
	user = user_login()
	new_date,check_new_month = CheckDate(Account['Last_date'])
		
	if check_new_month == 1:
		for i in range(Account.get('Last_date')[0], new_date[0]):
			if Account.get(user)[6] != 0:
				ex_bill = Account.get(user)[4] # bill for last month
				for m in range(30):		#interest 0.05% per day
					ex_bill = ex_bill * (1 + 0.0005)
				new_bill = Account.get(user)[5]	# minimum payment bill for this month
				Account.get(user)[3] = Account.get(user)[3] - (ex_bill - Account.get(user)[4]) # extra interest last month for not repay
				Account.get(user)[4] = ex_bill + new_bill
			elif Account.get(user)[5] > 0:
				Account.get(user)[4] = Account.get(user)[4] + Account.get(user)[5]
				Account.get(user)[6] = 1
			Account_history[user][i] = Account.get(user)
		Account.get(user)[5] = 0
	Account['Last_date'] = new_date
	#print Account['Last_date']
		
	save_file(Account,0)
	save_file(Account_history,1)
	Account = load_file(0)
	
except:
	print "Initialize account settings"
	Account = initial_account()
	Account_history = {}
	for x in Account.keys():
		Account_history[x] = {}
	#user login
	user = user_login()
	Account['Last_date'],check_new_month = CheckDate(Account['Last_date'])
	save_file(Account,0)
	save_file(Account_history,1)
	Account = load_file(0)
	#print Account
	#print user

date = Account['Last_date']
log_date = str(date[0]) + '-' + str(date[1])
#print log_date
user_info = Account.get(user)
	
	
exit_script = 0
while exit_script != 1:
	print "\033[32m1.shopping \t\t2.Cash\033[0m"
	print "\033[32m3.Repayment \t\t4.Check account\033[0m"
	print "\033[32m5.change password \t6.Log out\033[0m"
	choice = number_choice()
	#print choice
	if choice == 1:
		shopping(Account.get(user))
	elif choice == 2:
		cashin(Account.get(user))
	elif choice == 3:
		Repayment(Account.get(user))
	elif choice == 4:
		print_bill(user_info)
	elif choice == 5:
		change_password(user_info)
	else: exit_script = 1
