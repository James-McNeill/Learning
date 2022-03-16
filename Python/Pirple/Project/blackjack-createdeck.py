# Create the deck for the blackjack game

# Going to use this to take a random order for the deck of cards
from random import shuffle

# Create deck for Blackjack game
def createDeck():
    Deck = [] # initial empty list to hold the list of cards
    
    faceValues = ["A", "J", "Q", "K"] # four face value cards
    for i in range(4): # Four different suits
        for card in range(2,11): # adding numbers
            Deck.append(str(card))
        
        for card in faceValues: # append the four face values
            Deck.append(card)
    shuffle(Deck)
    return Deck

# Instantiate the function
Deck = createDeck()
# Shuffle the deck of cards. This can be added into the function
# shuffle(Deck)
# Review the Deck that was created to check that all values are included
print(Deck)
