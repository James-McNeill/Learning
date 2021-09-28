# Performing some intial exploration of that dataset

# Drop columns that have at least three missing values
volunteer.dropna(axis=1, thresh=3)

# Check how many values are missing in the category_desc column
print(volunteer['category_desc'].isnull().sum())

# Subset the volunteer dataset
volunteer_subset = volunteer[volunteer['category_desc'].notnull()]

# Print out the shape of the subset
print(volunteer_subset.shape)
