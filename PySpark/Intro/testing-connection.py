# Import modules
from pyspark.sql import SparkSession
import pyspark
import os

# Create the spark instance
spark = SparkSession.builder.getOrCreate()

type(spark)

# Check the number of cores available
print(os.cpu_count())

# Check the spark session
spark.sparkContext

# Read a csv file and set the headers
df = (spark.read
      .options(header=True)
      .csv("/home/ec2-user/SageMaker/.../winedata.csv"))

# Lazy processing to display the first records within the PySparkDataFrame
df.show()

# Show type of the DataFrame
type(df)

# Working with a parquet file
df=(spark.read
    .options(header=2, inferSchema=True, sep="|")
    .parquet("/home/ec2-user/SageMaker/s3-user-bucket/.../trans")
   )
df.first()

# Display column names
df.columns

# Count of distinct rows
df.distinct().count()

# Data Types for each column
df.dtypes

# Show the pyspark.sql.dataframe.DataFrame structure
df.printSchema()

# Aiming to understand the size of the items within memory
import sys
# These are the usual ipython objects, including this one you are creating
ipython_vars = ['In', 'Out', 'exit', 'quit', 'get_ipython', 'ipython_vars']

# Get a sorted list of the objects and their sizes
sorted([(x, sys.getsizeof(globals().get(x))) for x in dir() if not x.startswith('_') and x not in sys.modules and x not in ipython_vars], key=lambda x: x[1], reverse=True)
