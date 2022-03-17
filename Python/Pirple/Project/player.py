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

Player1 = Player(["3", "7", "5"])
print(Player1)
# Player1.hit("K")
Player1.hit("A") # helps to debug the Ace value. Making sure it doesn't take 11 but takes 1
Player1.hit("A")
print(Player1)
Player1.betMoney(20)
# Player1.pay(20) # testing the pay amount
print(Player1.money, Player1.bet)
Player1.win(True) # player wins
print(Player1.money, Player1.bet)
Player1.play(["A", "K"])
Player1.betMoney(20)
Player1.win(True)
print(Player1)
print(Player1.money, Player1.bet) # check that the money stays the same after starting a new game
