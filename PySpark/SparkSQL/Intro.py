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
# 1. Calculate the running total between rows
# Add col running_total that sums diff_min col in each group. diff_min: difference in minutes between train stops during the journey
query = """
SELECT train_id, station, time, diff_min,
SUM(diff_min) OVER (PARTITION BY train_id ORDER BY time) AS running_total
FROM schedule
"""

# Run the query and display the result
spark.sql(query).show()

# 2. Add the next time between rows by using LEAD
query = """
SELECT 
ROW_NUMBER() OVER (ORDER BY time) AS row,
train_id, 
station, 
time, 
LEAD(time,1) OVER (PARTITION BY train_id ORDER BY time) AS time_next 
FROM schedule
"""
spark.sql(query).show()

# C. Dot Notation Vs SQL steps
# 1. Aggregation, step by step
# Give the identical result in each command
spark.sql('SELECT train_id, MIN(time) AS start FROM schedule GROUP BY train_id').show()
df.groupBy('train_id').agg({'time':'MIN'}).withColumnRenamed('min(time)', 'start').show()

# Print the second column of the result
spark.sql('SELECT train_id, MIN(time), MAX(time) FROM schedule GROUP BY train_id').show()
result = df.groupBy('train_id').agg({'time':'min', 'time':'max'})
result.show()
print(result.columns[1])

# 2. Aggregating the same column twice
# Dot notation logic
from pyspark.sql.functions import min, max, col
expr = [min(col("time")).alias('start'), max(col("time")).alias('end')]
dot_df = df.groupBy("train_id").agg(*expr)
dot_df.show()

# Write a SQL query giving a result identical to dot_df. This piece of code is less cumbersome
query = "SELECT train_id, MIN(time) as start, MAX(time) as end  FROM schedule GROUP BY train_id"
sql_df = spark.sql(query)
sql_df.show()

# 3. Aggregate dot SQL
# Import modules
from pyspark.sql import Window
from pyspark.sql.functions import lead

# Obtain the identical result using dot notation 
dot_df = df.withColumn('time_next', lead('time', 1)
                                .over(Window.partitionBy('train_id')
                                        .orderBy('time')
                                )
                        )

# 4. Convert window function from dot notation to SQL
# a. Dot notation
window = Window.partitionBy('train_id').orderBy('time')
dot_df = df.withColumn('diff_min', 
                    (unix_timestamp(lead('time', 1).over(window),'H:m') 
                     - unix_timestamp('time', 'H:m'))/60)

# b. SQL code
# Create a SQL query to obtain an identical result to dot_df
query = """
SELECT *, 
(UNIX_TIMESTAMP(LEAD(time, 1) OVER (PARTITION BY train_id ORDER BY time),'H:m') 
 - UNIX_TIMESTAMP(time, 'H:m'))/60 AS diff_min 
FROM schedule 
"""
sql_df = spark.sql(query)
sql_df.show()
