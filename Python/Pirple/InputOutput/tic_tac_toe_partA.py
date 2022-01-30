# Creating a tic tac toe game

# A. Create the initial function to draw field
def drawField():
  for row in range(5):
    if row % 2 == 0:
      for column in range(5):
        if column % 2 == 0:
          if column != 4:
            print(" ", end="")
          else:
            print(" ")
        else:
          print("|", end="")
    else:
      print("-----")
