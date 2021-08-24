# Spark session has already been switched on

# Specify the option to drop invalid rows
ratings = (spark
           .read
           .options(header=True, mode="DROPMALFORMED")
           .csv("/home/repl/workspace/mnt/data_lake/landing/ratings_with_invalid_rows.csv"))
ratings.show()

# Fill missing values within a variable
print("BEFORE")
ratings.show()

print("AFTER")
# Replace nulls with arbitrary value on column subset
ratings = ratings.fillna(4, subset=["comfort"])
ratings.show()

# Conditionally replacing values using when() function
from pyspark.sql.functions import col, when

# Add/relabel the column
categorized_ratings = ratings.withColumn(
    "comfort",
    # Express the condition in terms of column operations
    when(col("comfort") > 3, "sufficient").otherwise("insufficient"))

categorized_ratings.show()
