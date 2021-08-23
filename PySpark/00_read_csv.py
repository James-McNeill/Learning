# Start a pyspark session
from pyspark.sql import SparkSession

# Create the spark instance
spark = SparkSession.builder.getOrCreate()

# Read a csv file and set the headers
df = (spark.read
      .options(header=True)
      .csv("/home/repl/workspace/mnt/data_lake/landing/ratings.csv"))

# The operation of importing all the data only takes place when operations are performed.
# The show method will display the first 20 rows from the csv file
df.show()

# Define the schema
schema = StructType([
  StructField("brand", StringType(), nullable=False),
  StructField("model", StringType(), nullable=False),
  StructField("absorption_rate", ByteType(), nullable=True),
  StructField("comfort", ByteType(), nullable=True)
])

# Apply the schema to make use of more appropriate data types. These help when performing
# future operations
better_df = (spark
             .read
             .options(header="true")
             # Pass the predefined schema to the Reader
             .schema(schema)
             .csv("/home/repl/workspace/mnt/data_lake/landing/ratings.csv"))
pprint(better_df.dtypes)
