# Aggregation pipeline construction

# A. Intro to aggregation
# 1. Aggregating a few individuals' country data
# Cursor equivalent
cursor = (db.laureates.find(
    {"gender": {"$ne": "org"}},
    ["bornCountry", "prizes.affiliations.country"]
).limit(3))

# Aggregation pipeline
# Translate cursor to aggregation pipeline
pipeline = [
    {"$match": {"gender": {"$ne": "org"}}},
    {"$project": {"bornCountry": 1, "prizes.affiliations.country": 1}},
    {"$limit": 3}
]

for doc in db.laureates.aggregate(pipeline):
    print("{bornCountry}: {prizes}".format(**doc))

# 2. 
