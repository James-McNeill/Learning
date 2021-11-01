# Caching with PySpark

# Caching invovles putting the dataframe into memory where it performs the initial operation first and all data is available for use immediately.
# Need to be careful and not cache all DataFrames as the more computationally intensive operations are then the slower the machine nodes will
# be able to work.

# Unpersists df1 and df2 and initializes a timer
prep(df1, df2) 

# Cache df1
df1.cache()

# Run actions on both dataframes
run(df1, "df1_1st") 
run(df1, "df1_2nd")
run(df2, "df2_1st")
run(df2, "df2_2nd", elapsed=True)

# Prove df1 is cached
print(df1.is_cached)
