# Working with DataFrame and PySpark SQL code
# We have to use the SparkSession method when working with PySpark SQL

# 1. Create DataFrame using RDD
# Create an RDD from the list
rdd = sc.parallelize(sample_list)

# Create a PySpark DataFrame
names_df = spark.createDataFrame(rdd, schema=['Name', 'Age'])

# Check the type of names_df - displays that a spark DataFrame has been created
print("The type of names_df is", type(names_df))

# 2. Create DataFrame using CSV file
# Create an DataFrame from file_path
# inferSchema: allows the method to infer the data type for each column within the DataFrame
people_df = spark.read.csv(file_path, header=True, inferSchema=True)

# Check the type of people_df
print("The type of people_df is", type(people_df))
