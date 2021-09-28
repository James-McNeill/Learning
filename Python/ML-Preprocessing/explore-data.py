# Performing some intial exploration of that dataset

# Drop columns that have at least three missing values
volunteer.dropna(axis=1, thresh=3)
