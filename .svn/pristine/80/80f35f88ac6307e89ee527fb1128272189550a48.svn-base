f = file('shops.txt')
products = []
prices = []

for line in f.readlines():
        new_line = line.split()
	products.append(new_line[0])
	prices.append(new_line[1])
print products
print prices
salary = int(raw_input('input your salary:'))
while True:
    print 'Welcome,you can buy as below'
    for p in products:
      p_index = products.index(p)
      p_price = prices[p_index]
      print p,p_index,p_price
    break
