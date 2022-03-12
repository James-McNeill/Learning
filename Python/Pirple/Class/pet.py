# Working with Pet Class
class Pet:
    
    def __init__(self, name, a, h, p):
        self.name = name
        self.age = a
        self.hunger = h
        self.playful = p
        
    # getters
    def getName(self):
        return self.name
    
    def getAge(self):
        return self.age
    
    def getHunger(self):
        return self.hunger
    
    def getPlayful(self):
        return self.playful
    
    # setters
    def setName(self, xname):
        self.name = xname
    
    def setAge(self, Age):
        self.age = Age
    
    def setHunger(self, hunger):
        self.hunger = hunger
    
    def setPlayful(self, play):
        self.playful = play

# # Instantiate the class
# Pet1 = Pet("Jim", 3, False, True)

# # Working with the class
# print(Pet1.getName())
# print(Pet1.getPlayful())
# Pet1.setName("Snowball")
# print(Pet1.getName())
# print(Pet1.name)
# Pet1.name = "Jim"
# print(Pet1.name)
        
# Class inheritance example
class Dog(Pet):
    def __init__(self, name, age, hunger, playful, breed, FavouriteToy):
        super().__init__(name, age, hunger, playful) # refering to the inherited class initiatliser
        self.breed = breed
        self.FavouriteToy = FavouriteToy
    
    def wantsToPlay(self):
        if self.playful:
            return ("Dog wants to play with " + self.FavouriteToy)
        else:
            return ("Dog doesn't want to play")

# Instantiate the new dog class
huskyDog = Dog("Snowball", 5, False, True, "Husky", "Stick")
# Use the method to check
Play = huskyDog.wantsToPlay()
print(Play)
# Adjust the playful variable parameter value
huskyDog.playful = False
Play = huskyDog.wantsToPlay()
print(Play)
