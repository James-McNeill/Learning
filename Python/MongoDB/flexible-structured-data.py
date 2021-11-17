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

