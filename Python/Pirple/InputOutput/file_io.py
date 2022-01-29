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
TheWholeFile = VacationFile.read() # Be careful if the file is large
print(TheWholeFile)

VacationFile.close()
