# Creating a tic tac toe game

# A. Create the initial function to draw field
# Create the tic tac toe board
def drawField(field: list):
  for row in range(5):
    if row % 2 == 0:
      practicalRow = int(row / 2)
      for column in range(5):
        if column % 2 == 0:
          practicalColumn = int(column / 2)
          if column != 4:
            print(field[practicalColumn][practicalRow], end="")
          else:
            print(field[practicalColumn][practicalRow])
        else:
          print("|", end="")
    else:
      print("-----")

# Creating the user moves
Player = 1
currentField = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
drawField(currentField)
while(True):
    print("Players turn: ", Player)
    MoveRow = int(input("Please enter the row\n"))
    MoveColumn = int(input("Please enter the column\n"))
    if Player == 1:
        # player 1 move
        if currentField[MoveColumn][MoveRow] == " ":
          currentField[MoveColumn][MoveRow] = "X"
          Player = 2 # switches player
    else:
        # player 2
        if currentField[MoveColumn][MoveRow] == " ":
          currentField[MoveColumn][MoveRow] = "O"
          Player = 1 # switches player
    drawField(currentField)
