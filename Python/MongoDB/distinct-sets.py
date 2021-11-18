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

# 3. Organizations and prizes over time
# Save a filter for organization laureates with prizes won before 1945
before = {
    "gender": "org",
    "prizes.year": {"$lt": "1945"},
    }

# Save a filter for organization laureates with prizes won in or after 1945
in_or_after = {
    "gender": "org",
    "prizes.year": {"$gte": "1945"},
    }

n_before = db.laureates.count_documents(before)
n_in_or_after = db.laureates.count_documents(in_or_after)
ratio = n_in_or_after / (n_in_or_after + n_before)
print(ratio)

# D. Distinct as you like
# 1. Searching for the regular expressions
# ^G: This searches for the G at the beginning of the text
db.laureates.count_documents({"firstname": Regex("^G"), "surname": Regex("^S")})

# 2. Searching for strings
from bson.regex import Regex

# Filter for laureates with a "bornCountry" value starting with "Germany"
criteria = {"bornCountry": Regex("^Germany")}
print(set(db.laureates.distinct("bornCountry", criteria)))

# Fill in a string value to be sandwiched between the strings "^Germany " and "now"
criteria = {"bornCountry": Regex("^Germany " + "\\(" + "now")}
print(set(db.laureates.distinct("bornCountry", criteria)))

#Filter for currently-Germany countries of birth. Fill in a string value to be sandwiched between the strings "now" and "$"
criteria = {"bornCountry": Regex("now" + " Germany\\)" + "$")}
print(set(db.laureates.distinct("bornCountry", criteria)))

