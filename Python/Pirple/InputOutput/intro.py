# Input and Output (I/O)
  
# A. Introduction to I/O
# Var = input("Message to the user") # simple variable to request information from user

Name = input("Please enter your name: ")
print(Name)

Age = int(input("Please enter your age: "))
print(Age)

Scores = []
for i in range(5):
  currentScore = int(input("Please enter the score"+str(i+1)+":"))
  Scores.append(currentScore)
  print("The score you entered was:", currentScore)

print(Scores)
