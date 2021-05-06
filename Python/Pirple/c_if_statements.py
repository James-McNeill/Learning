# Reviewing if someone clicked a like button on Facebook
# Initial values
click = False
Like = 0

click = True

if click == True:
    Like += 1
    click = False # Reset click feature

# print(Like)

Temperature = 20
Thermo = 15
print(Thermo)
if Temperature <= 15:
    Thermo += 5

print(Thermo)

if Temperature >= 20:
    Thermo -= 3

print(Thermo)

Time = "Day"
Sleepy = False
Pajamas = "Off"

if Time == "Night":
    Pajamas = "On"
elif Time == "Morning":
    Pajamas = "On"
else:
    Pajamas = "Off"

print(Pajamas)
