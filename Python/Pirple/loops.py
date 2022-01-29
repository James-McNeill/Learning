Word = "Hello"

Letters = []

for w in Word:
    print(w)
    if w == "e":
        print("Funny")
    
    Letters.append(w)

print(Letters)

Numbers = [1,2,3,4,5]

for l in Numbers:
    print(l)

Numbers1 = []

# for num in range(10):
for num in range(-1, 13, 3):
    Numbers.append(num)
    print(num)

# While loops
counter = 1
while (counter <= 10):
    print(counter)
    counter += 1

# Break loop
Participants = ["Jen", "Alex", "Tina", "Joe", "Ben"]

position = 1
for name in Participants:
    if name == "Tina":
        print("About to break")
        break
    print("About to increment")
    position = position + 1

print(position)

# Continue loop
for number in range(10):
    if number % 3 == 0:
        print(number)
        continue
    print("Not")
