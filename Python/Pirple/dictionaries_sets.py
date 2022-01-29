# Working with sets and dictionaries

# A. Sets - order does not matter but all values are unique
Sets = {"Element1", "Element2", "Element1", "Element4")}
print(Sets)
>> "Element1", "Element2", "Element4"

# Example for country
CountryList = []
for i in range(5):
  Country = input("Please enter your Country: ")
  CountryList.append(Country)

# Will only keep the unique values
CountrySet = set(CountryList)

print(CountryList)
print(CountrySet)

# Check for country in set
if "Brazil" in CountrySet:
  print("attended")

# B. Dictionaries
Dictionary = {
  "Key":"Value",
  "Key2":"Value2",
  "Key3":"Value3"
}

CountryDict = {} # Create empty dictionary
for Country in CountryList:
  if Country in CountryDict: # checks if the country key already exists
    CountryDict[Country] += 1
  else:
    CountryDict[Country] = 1 # if the country key doesn't exist, add the new key and increment

print(CountryDict)
