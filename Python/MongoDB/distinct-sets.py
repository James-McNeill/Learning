# Working with distinct() and sets

# A. Distinct values
# 1. Comparing sets
# Countries recorded as countries of death but not as countries of birth. Distinct method will show the unique values in the document
countries = set(db.laureates.distinct("diedCountry")) - set(db.laureates.distinct("bornCountry"))
print(countries)

# 2. Count countries of affiliation
# The number of distinct countries of laureate affiliation for prizes
count = len(db.laureates.distinct("prizes.affiliations.country"))
print(count)

# B. Distinct values given filters
# 1. Born here, went there
# In which countries have USA-born laureates had affiliations for their prizes? The string works as a pipe operation for the distinct method. So
# the filter will work in the second parameter to create the list of filtered values that are then used to perform the distinct operation on the
# first parameter. In this case the unique list of countries will be returned were the prizes were affiliated to
db.laureates.distinct("prizes.affiliations.country", {"bornCountry":"USA"})
