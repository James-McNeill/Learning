# Introduction to using MongoDB

# A MongoDB database can consist of several collections. Collections, in turn, consist of documents, which store the data.
# Recall that you can access databases by name as attributes of the client, like client.my_database (a connected client is 
# already provided to you as client). Similarly, collections can be accessed by name as attributes of databases (my_database.my_collection).

# A. Introduction
# 1. Count documents in a collection
# Import modules
from pymongo import MongoClient

# Client connects to "localhost" by default
client = MongoClient()

# Count documents
# Use empty document {} as a fitler
filter = {}

# Count documents in a collection
n_prizes = client.nobel.prizes.count_documents(filter)
n_laureates = client.nobel.laureates.count_documents(filter)

# 2. Listing databases and collections
# Every Mongo host has 'admin' and 'local' databases for internal bookkeeping, and every Mongo database has a
# 'system.indexes' collection to store indexes that make searches faster.

# Save a list of names of the databases managed by client
db_names = client.list_database_names()
print(db_names)

# Save a list of names of the collections managed by the "nobel" database
nobel_coll_names = client.nobel.list_collection_names()
print(nobel_coll_names)

# 3. List fields of a document
# Connect to the "nobel" database
db = client.nobel

# Retrieve sample prize and laureate documents
prize = db.prizes.find_one()
laureate = db.laureates.find_one()

# Print the sample prize and laureate documents
print(prize)
print(laureate)
print(type(laureate))

# Get the fields present in each type of document
prize_fields = list(prize.keys())
laureate_fields = list(laureate.keys())

print(prize_fields)
print(laureate_fields)

# B. Finding documents
# 1. Filtering for content
# The filter is applied within the count_documents() method. The notation $ is used to highlight the keywords and/or symbols being applied.
# Filters are applied using lexicographic formatting. This format will account for the ordering of data in the background, therefore alphabetic filtering
# will take place automatically.
db.laureates.count_documents({"born":{"$lt":"1800"}})

# 2. Composing filters
# Create a filter for laureates who died in the USA
criteria = {"diedCountry": "USA"}

# Save the count of these laureates
count = db.laureates.count_documents(criteria)
print(count)

# Create a filter for laureates who died in the USA but were born in Germany
criteria = {"diedCountry": "USA", 
            "bornCountry": "Germany"}

# Save the count
count = db.laureates.count_documents(criteria)
print(count)

# Create a filter for Germany-born laureates who died in the USA and with the first name "Albert"
criteria = {"diedCountry": "USA", 
            "bornCountry": "Germany", 
            "firstname": "Albert"}

# Save the count
count = db.laureates.count_documents(criteria)
print(count)

# 3. Filtering with options
# Save a filter for laureates born in the USA, Canada, or Mexico
criteria = { "bornCountry": 
                { "$in": ["USA", "Canada", "Mexico"]}
             }

# Count them and save the count
count = db.laureates.count_documents(criteria)
print(count)
