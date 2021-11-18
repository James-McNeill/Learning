# Methods to help improve searching

# A. Projection
# 1. Minimum projection to get data required
# "_id":0, this clause means that the _id variable will be excluded from the results. Whereas the value of one ensures that columns are included
db.laureates.find_one(
  {"prizes": {"$elemMatch": {"category": "physics", "year": "1903"}}}, 
  projection={"firstname":1, "surname":1, "prizes.share":1, "_id":0}
)

# 2. Finding laureates with initials of G.S for firstname and surname
# Use projection to select only firstname and surname
docs = db.laureates.find(
       filter= {"firstname" : {"$regex" : "^G"},
                "surname" : {"$regex" : "^S"}  },
   projection= ["firstname", "surname"]  )

# Iterate over docs and concatenate first name and surname
full_names = [doc["firstname"] + " " + doc["surname"]  for doc in docs]

# Print the full names
print(full_names)

# 3. Data validation on the shares for each prize to ensure that they all add up to 1
# Save documents, projecting out laureates share
prizes = db.prizes.find({}, ["laureates.share"])

# Iterate over prizes
for prize in prizes:
    # Initialize total share
    total_share = 0
    
    # Iterate over laureates for the prize
    for laureate in prize["laureates"]:
        # add the share of the laureate to total_share. Had to convert share value to float as it was stored as a string
        total_share += 1 / float(laureate["share"])
        
    # Print the total share    
    print(total_share)    

# B. Sorting
# 1. Initial sorting. Using a 1 for sort represents ascending order, with a -1 showing descending
docs = list(db.laureates.find(
    {"born": {"$gte": "1900"}, "prizes.year": {"$gte": "1954"}},
    {"born": 1, "prizes.year": 1, "_id": 0},
    sort=[("prizes.year", 1), ("born", -1)]))
for doc in docs[:5]:
    print(doc)

# 2. Sorting together MongoDB + Python
from operator import itemgetter

def all_laureates(prize):  
  # sort the laureates by surname
  sorted_laureates = sorted(prize["laureates"], key=itemgetter("surname"))
  
  # extract surnames
  surnames = [laureate["surname"] for laureate in sorted_laureates]
  
  # concatenate surnames separated with " and " 
  all_names = " and ".join(surnames)
  
  return all_names

# test the function on a sample doc
# print(all_laureates(sample_prize))

# find physics prizes, project year and name, and sort by year
docs = db.prizes.find(
           filter= {"category": "physics"}, 
           projection= ["year", "laureates.firstname", "laureates.surname"], 
           sort= [("year", 1)])

# print the year and laureate names (from all_laureates)
for doc in docs:
  print("{year}: {names}".format(year=doc["year"], names=all_laureates(doc)))

# 3. Gap years. Review original list of award categories and check for awards by year
# original categories from 1901
original_categories = db.prizes.distinct("category", {"year": "1901"})
print(original_categories)

# project year and category, and sort
docs = db.prizes.find(
        filter={},
        projection = {"year":1, "category":1, "_id":0},
        sort=[("year",-1),("category",1)]
)

#print the documents
for doc in docs:
  print(doc)

# C. Indexes
# 1. Recently single. Aiming to find the most recent time that a single prize was awarded for a category.
# Creating the index helps to speed up the algorithm within the query. It also means that the query can perform
# without having to always explicitly calling out the sorting

# Specify an index model for compound sorting
index_model = [("category", 1), ("year", -1)]
db.prizes.create_index(index_model)

# Collect the last single-laureate year for each category
report = ""
for category in sorted(db.prizes.distinct("category")):
    doc = db.prizes.find_one(
        {"category": category, "laureates.share": "1"},
        sort=[("year", -1)]
    )
    report += "{category}: {year}\n".format(**doc)

print(report)

# 2. Born and affiliated
from collections import Counter

# Ensure an index on country of birth
db.laureates.create_index([("bornCountry", 1)])

# Collect a count of laureates for each country of birth
n_born_and_affiliated = {
    country: db.laureates.count_documents({
        "bornCountry": country,
        "prizes.affiliations.country": country
    })
    for country in db.laureates.distinct("bornCountry")
}

five_most_common = Counter(n_born_and_affiliated).most_common(5)
print(five_most_common)

# D. Limits
# 1. Chaining methods. The use of two limits is similar to a variable update in Python, so the second limit will be applied 
list(db.prizes.find({"category": "economics"},
                    {"year": 1, "_id": 0})
     .sort("year")
     .limit(3)
     .limit(5))

# 2. The first five prizes with a quarter share
from pprint import pprint

# Fetch prizes with quarter-share laureate(s)
filter_ = {"laureates.share": "4"}

# Save the list of field names
projection = ["category", "year", "laureates.motivation"]

# Save a cursor to yield the first five prizes
cursor = db.prizes.find(filter_, projection).sort("year").limit(5)
pprint(list(cursor))
