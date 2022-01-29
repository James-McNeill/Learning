# Creating loop shapes

Length = 10
toPrint = "b"

# Display the shape increasing in size
for pos in range(1, Length + 1):
  print(toPrint * pos)
  
# Display the shape descreasing in size
# range(start, stop, increment)
for pos in range(Length, 0, -1): 
  print(toPrint * pos)
  
# Nested Loops
for row in range(5):
  if row % 2 == 0:
    for column in range(1, 6):
      if column % 2 == 1: # check for odd number
        if column != 5:
          print(" ", end="") # stops the print on a new line
        else:
          print(" ")
      else:
        print("|", end="") # print for even number
    print(" | | ")
  else:
    print("-----")
