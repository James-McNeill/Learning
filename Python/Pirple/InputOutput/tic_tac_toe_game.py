# Creating a tic tac toe game

# A. Create the initial function to draw field
# Create the tic tac toe board
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

# Draw the empty board
drawField()

# Creating the user moves
Player = 1
currentField = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
print(currentField)
while(True):
    print("Players turn: ", Player)
    MoveRow = int(input("Please enter the row\n"))
    MoveColumn = int(input("Please enter the column\n"))
    if Player == 1:
        # player 1 move
        currentField[MoveColumn][MoveRow] = "X"
        Player = 2 # switches player
    else:
        # player 2
        currentField[MoveColumn][MoveRow] = "O"
        Player = 1 # switches player
    print(currentField)
