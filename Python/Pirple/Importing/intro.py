
# Import a package
import random as r

# random.seed(1) # maintains a memory of the random state. Means that the starting value will be constant
randInt = r.randint(0, 10) # start, end
print(randInt)

# Setting the random seed works well when aiming to replicate results. Can be used with ML models

randFloat = r.random() # range start >= 0, end < 1
print(randFloat)

randUniform = r.uniform(1, 11) # All values included in range
print(randUniform)

simpleList = [1, 3, 5, 7, 11]
pickElement = r.choice(simpleList)
print(pickElement)
print(simpleList)

# Shuffle the order of elements
r.shuffle(simpleList)
print(simpleList)
