#!/usr/bin/env python
import sys
f = file('shopping')
products = []
prices = []
shop_list = []
for line in f.readlines():
	new_line = line.split()
	products.append(new_line[0])
	prices.append(int(new_line[1]))
#print products,prices

salary = int(raw_input("Pls input your salary:"))

while True:
	print "Welcom,things you can buy as below:"
	for p in products:
		p_index = products.index(p)
		p_prices = prices[p_index]
		print p , p_index, p_prices
	choice = raw_input("Pls input what you want to buy:")
	f_choice = choice.strip()
	if f_choice in products:
		print '\033[36;1m yes,It is in the list: \033[0m'
		f_index = products.index(f_choice)
		f_price = prices[f_index]
		if salary >= f_price:
			print '\033[34;1m Congratulations, added %s to shoplist \033[0m' % f_choice  
			shop_list.append(f_choice)
			salary = salary - f_price
			print "\033[35;1m The salary left is : %d! keep buying! \033[0m" % salary
		else:
			if salary < min(prices):
				print '\033[31;1m You can not byt any thing, Bye! \033[0m'
				print "\033[39;1m %s\033[0m" % shop_list
				sys.exit()
			else:
				print '\033[37;1m Sorry, money is not enough to buy %s, Pls try another one! \033[0m' % f_choice
	else:
		print '\033[36;1m sorry,%s not in the list: \033[0m' % f_choice
