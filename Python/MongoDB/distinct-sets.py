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

# 2. Triple plays
# Save a filter for prize documents with three or more laureates
criteria = {"laureates.2": {"$exists": True}}

# Save the set of distinct prize categories in documents satisfying the criteria
triple_play_categories = set(db.prizes.distinct("category", criteria))

# Confirm literature as the only category not satisfying the criteria.
assert set(db.prizes.distinct("category")) - triple_play_categories == {"literature"}

# C. Filter arrays using distinct values
# 1. Sharing of physics prizes
# $elemMatch: method proveis the option to add multiple filter clauses
db.laureates.count_documents({
    "prizes": {"$elemMatch": {
        "category": "physics",
        "share": {"$ne": "1"},
        "year": {"$lt": "1945"}}}})

# 2. Sharing in other categories
# Save a filter for laureates with unshared prizes
unshared = {
    "prizes": {"$elemMatch": {
        "category": {"$nin": ["physics", "chemistry", "medicine"]},
        "share": "1",
        "year": {"$gte": "1945"},
    }}}

# Save a filter for laureates with shared prizes
shared = {
    "prizes": {"$elemMatch": {
        "category": {"$nin": ["physics", "chemistry", "medicine"]},
        "share": {"$ne": "1"},
        "year": {"$gte": "1945"},
    }}}

ratio = db.laureates.count_documents(unshared) / db.laureates.count_documents(shared)
print(ratio)
