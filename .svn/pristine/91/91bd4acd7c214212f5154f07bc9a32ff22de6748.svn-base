#!/usr/bin/env python

shoptest = file('shopping').read()
shop = shoptest.split()
x=0;y=1;A=[];B=[]
count = len(open('shopping','rU').readlines())
count = count*2-1
shop_list = []
#print count
while True:
	A.append(shop[x])
	x = x + 2
	B.append(shop[y])
	y = y + 2
	if x >= count:break
#print A
#print B

salary = int(raw_input("Pls input your salary:"))
#print salary
while True:
	print "Things have in the shop, please choose one the buy:"
	for p in A:
		print p,'\t',B[A.index(p)]
	choice = raw_input('Pls input one item to buy:')
	F_choice = choice.strip()
	print F_choice
	if F_choice in A:
		A_price_index = A.index(F_choice)
		A_price = B[A_price_index]
		print F_choice,A_price,salary
		if salary > int(A_price):
			shop_list.append(F_choice)
			print "Added %s into you shop list" % F_choice
			salary = salary - int(A_price)
			print "Salary left:", salary
		else:
			if salary < min(B):
				print "Sorry,reset of your salary cannot buy anthing! 88"
				print "you hava bought these things: %s" % shop_list	
			else:
				print "Sorry, you cannot afford this, Pls try other ones!"














