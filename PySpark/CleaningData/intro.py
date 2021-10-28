# Introduction to cleaning data with PySpark

# Import the pyspark.sql.types library
from pyspark.sql.types import *

# Define a new schema using the StructType method
people_schema = StructType([
  # Define a StructField for each field
  StructField('name', StringType(), False),
  StructField('age', IntegerType(), False),
  StructField('city', StringType(), False)
])

# Using lazy processing: data will not be processed until an action method is called
# Load the CSV file
aa_dfw_df = spark.read.format('csv').options(Header=True).load('AA_DFW_2018.csv.gz')

# Add the airport column using the F.lower() method
aa_dfw_df = aa_dfw_df.withColumn('airport', F.lower(aa_dfw_df['Destination Airport']))

# Drop the Destination Airport column
aa_dfw_df = aa_dfw_df.drop(aa_dfw_df['Destination Airport'])

# Show the DataFrame: this is the action method which will process the prior steps
aa_dfw_df.show()

# 2. Working with parquet files
# The Parquet format is a columnar data store, allowing Spark to use predicate pushdown. The parquet format is the optimal
# dataset format for Spark to process with as the variable schema is defined prior to importing datasets. When using another
# dataset format by importing the data the Spark processing has to review all rows of the dataset prior to defining the variable
# schema. This in turn takes a lot of processing and can slow down the benefits that Spark provides.
# This means Spark will only process the data necessary to complete the operations you define versus reading the entire dataset. 
# This gives Spark more flexibility in accessing the data and often drastically improves performance on large datasets.

# View the row count of df1 and df2
print("df1 Count: %d" % df1.count())
print("df2 Count: %d" % df2.count())

# Combine the DataFrames into one
df3 = df1.union(df2)

# Save the df3 DataFrame in Parquet format
df3.write.parquet('AA_DFW_ALL.parquet', mode='overwrite')

# Read the Parquet file into a new DataFrame and run a count
print(spark.read.parquet('AA_DFW_ALL.parquet').count())
