# Working with sets and dictionaries

# Sets - order does not matter but all values are unique
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
