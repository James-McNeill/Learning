# Caching with PySpark

# Caching invovles putting the dataframe into memory where it performs the initial operation first and all data is available for use immediately.
# Need to be careful and not cache all DataFrames as the more computationally intensive operations are then the slower the machine nodes will
# be able to work.

# 1. Cache DataFrames
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

# 2. Alternative method to cache the DataFrame
# Unpersist df1 and df2 and initializes a timer
prep(df1, df2) 

# Persist df2 using memory and disk storage level. This is the default setting. Whenever this is being used it will perform the exact same operations
# as the cache() method.
df2.persist(storageLevel=pyspark.StorageLevel.MEMORY_AND_DISK)

# Run actions both dataframes
run(df1, "df1_1st") 
run(df1, "df1_2nd") 
run(df2, "df2_1st") 
run(df2, "df2_2nd", elapsed=True)

# 3. Cache and uncache tables
# List the tables
print("Tables:\n", spark.catalog.listTables())

# Cache table1 and Confirm that it is cached
spark.catalog.cacheTable('table1')
print("table1 is cached: ", spark.catalog.isCached('table1'))

# Uncache table1 and confirm that it is uncached
spark.catalog.uncacheTable('table1')
print("table1 is cached: ", spark.catalog.isCached('table1'))
