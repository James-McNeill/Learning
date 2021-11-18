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
# 1. 
