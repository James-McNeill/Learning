# Code is taken from the player class to be used with the code below

# printing house hand and hiding first card
def printHouse(House):
    for card in range(len(House.hand)):
        if card == 0:
            print("X", end= " ") # continue printing on the same line
        elif card == len(House.hand) - 1:
            print(House.hand[card]) # make sure that this is the end of the line with the last card
        else:
            print(House.hand[card], end = " ") # all other cards in the hand

# Create the shuffled card deck
cardDeck = createDeck()

# First hand being picked
firstHand = [cardDeck.pop(), cardDeck.pop()]
secondHand = [cardDeck.pop(), cardDeck.pop()]
# Instantiate the class
Player1 = Player(firstHand)
House = Player(secondHand)
print(cardDeck)
printHouse(House)
print(Player1)
# requesting input from the user
while(Player1.score < 21): 
    action = input("Do you want another card?(y/n): ")
    if action == "y":
        Player1.hit(cardDeck.pop())
        print(Player1)
        printHouse(House)
    else:
        break # break out of the loop

print(House) # shows what they have after the player has played
