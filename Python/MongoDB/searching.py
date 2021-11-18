# Methods to help improve searching

# A. Projection
# 1. Minimum projection to get data required
# "_id":0, this clause means that the _id variable will be excluded from the results. Whereas the value of one ensures that columns are included
db.laureates.find_one(
  {"prizes": {"$elemMatch": {"category": "physics", "year": "1903"}}}, 
  projection={"firstname":1, "surname":1, "prizes.share":1, "_id":0}
)
