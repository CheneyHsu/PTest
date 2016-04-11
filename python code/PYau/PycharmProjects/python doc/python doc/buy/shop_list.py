#!/usr/bin/python

products = ['Car','Iphone','Coffee','Mac','Cloths','Bicyle']
prices   = [250000, 4999,     35,    9688,    438 ,  1500]
shop_list = []

salary = int(raw_input('please input your salary:'))

while True:
        print "Things have in the shop,please choose one to buy:"
        for p in products:
                # product_index =products.index(p)
                print p,'\t',prices[products.index(p)] 

        choice = raw_input('Please input one item to buy:')
        F_choice = choice.strip()
        if F_choice in products:
                product_price_index = products.index(F_choice)
                product_price = prices[product_price_index]
                print F_choice,product_price
                if salary > product_price:
                        shop_list.append(F_choice)
                        print "Added %s into your shop list" % F_choice
                        salary = salary - product_price
                        print "Salary left:",salary
                else:
                        if salary < min(prices):
                                print 'Sorry,rest of your salary cannot buy anything! 88';exit()
                                print "you have bought these things: %s "% shop_list
                        else:
                                print "Sorry , you cannot afford this product, please try other ones!"

