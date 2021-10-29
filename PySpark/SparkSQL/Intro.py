# Introduction to Spark SQL

# A. Create and Query the data
# 1. Load trainsched.txt
df = spark.read.csv("trainsched.txt", header=True)

# Create temporary table called table1
df.createOrReplaceTempView('table1')

