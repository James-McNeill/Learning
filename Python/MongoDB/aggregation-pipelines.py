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

# 2. Passing the aggregation baton to Python
from collections import OrderedDict
from itertools import groupby
from operator import itemgetter

original_categories = set(db.prizes.distinct("category", {"year": "1901"}))

# Save an pipeline to collect original-category prizes
pipeline = [
    {"$match": {"category": {"$in": list(original_categories)}}},
    {"$project": {"year": 1, "category": 1}},
    {"$sort": OrderedDict([("year", -1)])}
]
cursor = db.prizes.aggregate(pipeline)
for key, group in groupby(cursor, key=itemgetter("year")):
    missing = original_categories - {doc["category"] for doc in group}
    if missing:
        print("{year}: {missing}".format(year=key, missing=", ".join(sorted(missing))))
