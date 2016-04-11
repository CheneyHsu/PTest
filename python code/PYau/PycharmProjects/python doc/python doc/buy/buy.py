#!/usr/bin/python
salary=int(raw_input("Pls input your salary:"))
print "===menu list is:==="
f = file('menu.list')
content = f.read()
print content,
print "==================="
select=raw_input("Pls input what you want to buy:")
menu_list_file = file('menu.list')
line=1
while True:
  line = menu_list_file.readline()
  #print line
  #exit()
  if select in line:
	  yuansu = line.split()
	  #print yuansu[1]
	  #print salary
	  #exit()
   	  price=int(yuansu[1])
	  #print "the price is",price,">",salary
          if  price > salary:
              print "sorry,your sallary is not enough"
	      break
	  else:
              salary = salary - price
              name = yuansu[0]
	      #print name;exit()
              namelist = []
	      namelist.append(name)
	      lang=len(namelist)
	      for n in range(1):
	        print 'the product you bought:',namelist[n]
                print "your money left :%s" % salary
  print content,
