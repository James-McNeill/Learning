# Working with files

# Interact with files
File = open("Filename", "r") # r: read, w: write, a: append, r+: read and write
# Important to make sure to close the connection with the files at the end of working with it
File.close()

# Task 
# Create a list of Cities. Write these into a file. Read from the file
Cities = ["London", "Paris", "New York", "Milan", "Oslo"]

# using write function. if the file doesn't exist a new file is created.
# if the file does exist then the contents will be overwritten.
# the file is going to be created in the same directory location that the current python file is stored
VacationFile = open("VacationPlaces", "w") 

# Add contents to the file
for City in Cities:
  VacationFile.write(City + " ") # This must be a string. Added a space separator

VacationFile.close()

# Lets read the file
VacationFile = open("VacationPlaces", "r") 

# Lets step through the lines within the read file
FirstLine = VacationFile.readline()
print(FirstLine)
for line in VacationFile:
  print(line, end="")

# TheWholeFile = VacationFile.read() # Be careful if the file is large
# print(TheWholeFile)

VacationFile.close()

# Append an additional city to the file
FinalSpot = "Dublin"
VacationFile = open("VacationPlaces", "a")
VacationFile.write(FinalSpot)
VacationFile.close()

# Read the file after the append
VacationFile = open("VacationPlaces", "r") 
for line in VacationFile:
  print(line, end="")

VacationFile.close()

# To ensure that the file doesn't remain open. Where the user forgets to close the file, we can use "with"
with open("VacationPlaces", "r") as VacationFile:
  for line in VacationFile:
    print(line, end="")
