# Game includes re-shuffling if the deck falls below 20 cards
# Future work could include adding more players using arrays

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

# Creating a class for the different players
class Player:
    
    # attributes for the class
    def __init__(self, hand = [], money = 100):
        self.hand = hand # current hand that the player has. List helps to retain the elements of hand
        # self.score = 0 # current score they have
        self.score = self.setScore() # allows the function to keep track of the score
        self.money = money # current capital assigned for the game
        self.bet = 0 # new player hasn't had a bet yet
        
    # value to be printed (print(player)) can be adjusted with the __str__() function
    def __str__(self): # aim is to return the hand and score
        currentHand = ""
        for card in self.hand:
            currentHand += str(card) + " " # combined the different cards with a space
        
        finalStatus = currentHand + "score: " + str(self.score)
        return finalStatus
    
    # creating the score for the player
    def setScore(self):
        # set the initial score
        self.score = 0
        # dictionary of values for cards
        # faceCardsDict = {"A": 11, "J": 10, "Q": 10, "K": 10}
        cardsDict = {"A": 11, "J": 10, "Q": 10, "K": 10,
                     "2": 2, "3": 3, "4": 4, "5": 5, "6": 6,
                     "7": 7, "8": 8, "9": 9, "10": 10}

        aceCounter = 0 # the ace card can take values of 1 and 11
        for card in self.hand:
            self.score += cardsDict[card]
            if card == "A":
                aceCounter += 1 # once an ace is drawn then the increment takes place
            if self.score > 21 and aceCounter != 0:
                self.score -= 10
                aceCounter -= 1 # after incrementing the ace counter then reduce the counter again
        return self.score # pass back the score value
    
    # hit a new card
    def hit(self, card):
        self.hand.append(card) # adding the new card to the hand list
        self.score = self.setScore() # after adding the new card then need to update score

    # creating a new hand
    def play(self, newHand):
        self.hand = newHand
        self.score = self.setScore()
    
    # creating a bet method
    def betMoney(self, amount):
        self.money -= amount
        self.bet += amount # money moves from money to bet variable
    
    # create a win method
    def win(self, result):
        if result:
            if self.score == 21 and len(self.hand) == 2:
                self.money += self.bet * 2.5 # extra winnings for getting a blackjack
            else:
                self.money += self.bet * 2 # a win gets double from the bet
            self.bet = 0
        else:
            self.bet = 0
    
    # check for a draw if player and house have the same score total
    def draw(self):
        self.money += self.bet # the bet is returned as a draw
        self.bet = 0
    
    # check for a blackjack hand, this would end the game
    def hasBlackjack(self):
        if self.score == 21 and len(self.hand) == 2:
            return True
        else:
            return False

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

firstHand = [cardDeck.pop(), cardDeck.pop()]
secondHand = [cardDeck.pop(), cardDeck.pop()]
Player1 = Player(firstHand)
House = Player(secondHand)

cardDeck = createDeck()
while(True):
    # check if we need to re-shuffle the card deck
    if len(cardDeck) < 20:
        cardDeck = createDeck()
    firstHand = [cardDeck.pop(), cardDeck.pop()]
    secondHand = [cardDeck.pop(), cardDeck.pop()]
    Player1.play(firstHand)
    House.play(secondHand)
    
    # place initial bet
    Bet = int(input("Please enter your bet: "))
    # place the bet
    Player1.betMoney(Bet)
    
    # print(cardDeck)
    printHouse(House)
    print(Player1)
    
    # check for Blackjack before asking for cards
    if Player1.hasBlackjack():
        if House.hasBlackjack():
            Player1.draw()
        else:
            Player1.win(True)
    else:
    # requesting input from the user
        while(Player1.score < 21): 
            action = input("Do you want another card?(y/n): ")
            if action == "y":
                Player1.hit(cardDeck.pop())
                print(Player1)
                printHouse(House)
            else:
                break # break out of the loop
    # house draws their cards until they at least have a value of 16
        while(House.score < 16):
            print(House)
            House.hit(cardDeck.pop())
        # check who was the winner or drew
        if Player1.score > 21:
            if House.score > 21:
                Player1.draw()
            else:
                Player1.win(False) # the house wins
        elif Player1.score > House.score: # player wins
            Player1.win(True)
        elif Player1.score == House.score: # same score is a draw
            Player1.draw()
        else:
            if House.score > 21:
                Player1.win(True)
            else:
                Player1.win(False)

    print(Player1.money)
    print(House) # shows what they have after the player has played
