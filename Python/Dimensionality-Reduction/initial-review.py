# Initial aim is to remove variables with no variance as they add no value

# Review the output stats for the std, min and max
df.describe()

# Review categorical features - remove variables with low cardinality
df.describe(exclude="number")
