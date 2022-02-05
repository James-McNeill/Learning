# Participant data files

# A. Creating the initial data file
# Participant Data
Number = 2
Data = []

Registered = 0
outputFile = open("ParticipantData.txt", "w")

while(Registered < Number):
    tempData = [] # name, country of origin, age
    name = input("Please enter your name: ")
    tempData.append(name)
    country = input("Please enter your country of origin: ")
    tempData.append(country)
    age = input("Please enter your age: ")
    tempData.append(age)
    print(tempData)
    Data.append(tempData)
    print(Data)
    Registered += 1

# Write data to file
for participant in Data:
    for data in participant:
        outputFile.write(str(data)) # output file requires strings
        outputFile.write(" ")
    outputFile.write("\n")

outputFile.close()
