# Complete pets class example
# Included a separate human class that is able to interact with the pet classes

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
    
    def __str__(self): # aiming to overwrite keyword
        return (self.name + " is " + str(self.age) + " years old")

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
        super().__init__(name, age, hunger, playful) # refering to the inherited class initialiser
        self.breed = breed
        self.FavouriteToy = FavouriteToy
    
    def wantsToPlay(self):
        if self.playful:
            return ("Dog wants to play with " + self.FavouriteToy)
        else:
            return ("Dog doesn't want to play")

# Class inheritance #2
class Cat(Pet):
    def __init__(self, name, age, hunger, playful, place):
        super().__init__(name, age, hunger, playful)
        self.FavouritePlaceToSit = place
    
    def wantsToSit(self):
        if self.playful == False:
            print("The cat wants to sit in", self.FavouritePlaceToSit)
        else:
            print("The cat wants to play")
    
    def __str__(self):
        return (self.name + " likes to sit in " + self.FavouritePlaceToSit)

# Human class is going to store the other classes within it
class Human:
    def __init__(self, name, Pets):
        self.name = name # format string
        self.Pets = Pets # format array
    
    # Check if the human has pets
    def hasPets(self):
        if len(self.Pets) != 0:
            return "yes"
        else:
            return "no"

# Instantiate the new dog class
huskyDog = Dog("Snowball", 5, False, True, "Husky", "Stick")
# Use the method to check
Play = huskyDog.wantsToPlay()
print(Play)
# Adjust the playful variable parameter value
huskyDog.playful = False
Play = huskyDog.wantsToPlay()
print(Play)

# Instantiate the new cat class
typicalCat = Cat("Fluffy", 3, False, False, "the sun ray")
typicalCat.wantsToSit()
print(typicalCat) # prints the __str__ method
print(Dog) # prints the standard information as the __str__ method was not updated
print(huskyDog) # uses the __str__ method from the Pet class

yourAverageHuman = Human("Alice", [huskyDog, typicalCat])
hasPet = yourAverageHuman.hasPets()
print(hasPet)
print(yourAverageHuman.Pets[0]) # reviews the first element of the array
print(yourAverageHuman.Pets[1]) # takes the str from the second element of the array
print(yourAverageHuman.Pets[1].name) # able to interact with the attributes within each class
