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

# B. Window functions
# Add col running_total that sums diff_min col in each group. diff_min: difference in minutes between train stops during the journey
query = """
SELECT train_id, station, time, diff_min,
SUM(diff_min) OVER (PARTITION BY train_id ORDER BY time) AS running_total
FROM schedule
"""

# Run the query and display the result
spark.sql(query).show()
