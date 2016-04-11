#!/bin/python

number = 23
running = True

while running:
	guess=int(input('Enter an integer'))
	
	if guess == number:
		print("Congratulation, you guessed it.")
		running=False
	elif guess < number:
		print("No,it is a little higher.")

	else:
		print("No,it is a little lower.")
else:
	print("The while loop is over.")
print("Done")            
