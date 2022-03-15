# Guessing game part A

# Import a package
# from random import randint

# randVal = randint(0,100)

# while(True):
#     guess = int(input("Please enter your guess: "))
#     if guess == randVal:
#         break
#     elif guess < randVal:
#         print("Your guess was too low")
#     else:
#         print("Your guess was too high")

# print("You guessed correctly with:", guess)

# Guessing game part B
from random import random
from time import process_time

randVal = random() # range between 0 and < 1
upper = 1.0
lower = 0.0

guess = 0.5 # initial guess

startTime = process_time()
while(True):
    if guess == randVal:
        break
    elif guess < randVal:
        lower = guess
    else:
        upper = guess
    guess = (upper + lower) / 2

endTime = process_time()
print(guess)
print("It took us:", endTime - startTime, "seconds")
