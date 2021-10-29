# Introduction to Spark SQL

# A. Create and Query the data
# 1. Load trainsched.txt
df = spark.read.csv("trainsched.txt", header=True)

# Create temporary table called table1
df.createOrReplaceTempView('table1')

# 2. Inspect the columns within a table
# Inspect the columns in the table df
spark.sql("DESCRIBE schedule").show()
# Alternative options
# spark.sql("SHOW COLUMNS FROM tablename").show()
# spark.sql("SELECT * FROM tablename LIMIT 0").show()
