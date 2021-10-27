# Working with DataFrame and PySpark SQL code
# We have to use the SparkSession method when working with PySpark SQL

# 1. Create DataFrame using RDD
# Create an RDD from the list
rdd = sc.parallelize(sample_list)

# Create a PySpark DataFrame
names_df = spark.createDataFrame(rdd, schema=['Name', 'Age'])

# Check the type of names_df
print("The type of names_df is", type(names_df))
