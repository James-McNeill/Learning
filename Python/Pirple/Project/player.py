# Creating a class for the different players
class Player:
    
    # attributes for the class
    def __init__(self, hand = [], money = 100):
        self.hand = hand # current hand that the player has. List helps to retain the elements of hand
        # self.score = 0 # current score they have
        self.score = self.setScore() # allows the function to keep track of the score
        self.money = money # current capital assigned for the game
        
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
        faceCardsDict = {"A": 11, "J": 10, "Q": 10, "K": 10}
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
            # if int(card) in range(2, 11):
            #     self.score += int(card)
            # elif card in faceCardsDict:
            #     self.score += faceCardsDict[card]
        return self.score # pass back the score value


Player1 = Player(["3", "7"])
print(Player1)
