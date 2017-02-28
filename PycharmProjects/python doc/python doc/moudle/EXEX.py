#   if
'''number = 23
guess = int(input('Enter an interger:'))
if guess == number:
    print('Congratulations, you guessed it.')
    print('(but you do not win any prizes!)')
elif guess < number:
    print('No,it is a little higer than that')
else:
    print('No,it is a little lower than that')
print('Done')'''


'''
#while
number1 = 23
running = True

while running:
    guess=int(input("Enter an interger:"))

    if guess == number1:
        print("Congratulation, you guessed it.")
        running=False
    elif guess < number1:
        print("No,it is a little higher.")
    else:
        print("No,it is a little lower.")
else:
    print("the while loop is over.")
print("Done")'''




'''
#for
for i in range (1,5):
    print(i)
else:
    print('the for loop is over')
'''



'''
#break
while True:
    s = (input('Enter something:'))
    if s == 'quit':
        break
    print('Length of the string is', len(s))
print('Done')
'''
'''
#continue
while True:
    s1 = input('Enter something:')
    if s1 == 'quit':
        break
    if len(s1) < 3:
        print('Too small')
    continue
    print('Input is of sufficient length')
'''

'''
#def sayhello
def sayhello():
    print('Hello World!')  #end def 
sayhello()
sayhello()  #call the function again
'''


'''
def printMax(a,b):
    if a > b:
        print(a, 'is maximum')
    elif a < b:
        print(b,'is maximum')
    else:
        print(a,'is equal to',b)
        
printMax(3,4)
'''

'''  
x = 50
def func(x):
    print('x is',x)
    x = 2
    print('Changed local x to',x)
func(x)
print('x is still', x)
'''
'''
#use gloabl def
x = 50
def func():
    global x
    
    print('x is ',x)
    x=2
    print('Changed global x to',x)
func()
print('Value of x is',x)
'''

'''
def say(message, time = 1):
    print(message * time)
say('hello')
say('world',5)
'''
'''
def func(a,b=5,c=10):
    print('a is',a ,'b is',b,'c is',c)
func(3,7)
func(25,c=24)
func(c=50,a=100)
'''

'''
def maximum(x,y):
    if x > y:
        return x
    else:
        return y
print(maximum(2,3))
'''

'''
def printMax(x,y):
    
    x = int(x)
    y = int(y)
    
    if x > y:
        print(x, 'is maximum')
    else:
        print(y, 'is maximum')
printMax(3,5)
print(printMax.__doc__)
'''

'''
import sys
print('The command line arguments are:')
for i in sys.argv:
    print(i)
print('\n\nThe PYTHONPATH is',sys.path,'\n')
'''

'''
import os;
print(os.getcwd())
'''

'''
if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another moudle')
'''

'''
import mymodule

mymodule.sayhi()
print('version',mymodule.__version__)
'''

'''
from mymodule import sayhi, __version__

sayhi()
print('version',__version__)
'''

'''
shoplist = ['apple', 'mango', 'carrot', 'banana']
print('I have',len(shoplist),'items to purchase.')
print('These items are:',end=' ')

for item in shoplist:
    print(item,end=' ')
print('\nI also have to buy rice.')
shoplist.append('rice')
print('My shopping list is now',shoplist)

print('I will sort my list now')
shoplist.sort()
print('Sorted shopping list is',shoplist[0])
olditem = shoplist[0]
del shoplist[0]
print('I bought the', olditem)
print('My shopping list is now',shoplist)
'''
  
'''      
zoo = ('python','elephant','penguin')
print('Number of animals in the zoo is', len(zoo))
new_zoo = ('monkey','camel',zoo)
print('Number of cages in the new zoo is',len(new_zoo))
print('All animals in new zoo are',new_zoo)
print('Animals brought from old zoo is', new_zoo[2])
print('Last animal brought from old zoo is',new_zoo[2][2])
print('Number of animals is the new zoo is',len(new_zoo)-1+len(new_zoo[2]))       
'''

'''
ab = { 'Swaroop' : 'swaroop@swaroop@swaroopch.com' ,
        'Larry' : 'Larry@wall.com',
          'Matsumoto' : 'matz@ruby-lang.org',
          'Spammer' : 'spammer@hotmail.com'  }

print("Swaroop's address is ", ab['Swaroop'])

del ab['Spammer']

print('\nThere are {0} contacts in the address-book\n'.format(len(ab)))

for name, address in ab.items():
    print('Contact {0} at {1}'.format(name, address))
    
ab['Guido'] = 'guidong@python.org'
if 'Guidong' in ab:
        print("\nGuidong's address is ", ab['Guidong'])

'''

'''

shoplist = ['apple' , 'mango', 'carrot' , 'banana']
name ='swaroop'

print('Item 0 is', shoplist[0])
print('Item 1 is', shoplist[1])
print('Item 2 is', shoplist[2])
print('Item 3 is', shoplist[3])
print('Item -1 is', shoplist[-1])
print('Item -2 is', shoplist[-2])
print('Character 0 is', name[0])

print('Item 1 to 3 is',shoplist[1:3])
print('Item 2 to end is',shoplist[2:])
print('Item 1 to -1 is',shoplist[1:-1])
print('Item start to end is ', shoplist[:])

print('characters 1 to 3 is',name[1:3])
print('characters 2 to end is',name[2:])
print('characters 1 to -1 is',name[1:-1])
print('characters start to end is',name[:])
'''

'''
print('Simple Assignment')
shoplist = ['apple' , 'mango','carrot','banana']
mylist = shoplist
del shoplist[0]

print('shoplist is',shoplist)

print('mylist is', mylist)

print('Copy by making a full slice')

mylist = shoplist[:]

del mylist[0]

print('shoplist is ' , shoplist)
print('mylist is ' , mylist)
'''

'''
name = 'Swaroop' 
if name.startswith('Swa'):
    print('Yes, the string starts with "Swa"')
if 'a' in name:
    print('Yes, it contains the string "a"')
if name.find('war') != -1:
    print('Yes, it contains the string "war"')
delimiter = '_*_'
mylist = ['Brazil', 'Russia', 'India', 'China']
print(delimiter.join(mylist))
'''

'''
def reverse(text):
    return text[::-1] 
def is_palindrome(text):
    return text == reverse(text)
something = input('Enter text:')
if (is_palindrome(something)):
    print("Yes, it is a palindrome") 
else:
    print("No,it is not a palindrome")
'''




