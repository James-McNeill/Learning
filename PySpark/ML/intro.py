# Introduction to ML in PySpark

# A. Machine Learning & Spark
# 1. All question and answers

# B. Connecting to Spark
# 1. Creating a SparkSession
# Import the SparkSession class
from pyspark.sql import SparkSession

# Create SparkSession object
# master: Can connect to a Remote Cluster or a local cluster. Remote cluster requires a Spark URL which includes the URL and port number
#         local options, local = 1 core, local[4] = 4 cores, local[*] = wildcard requests all cores
spark = SparkSession.builder \
                    .master('local[*]') \
                    .appName('test') \
                    .getOrCreate()

# What version of Spark?
print(spark.version)

# Terminate the cluster
spark.stop()

# C. Loading data
# 1. Loading flights data
# Read data from CSV file
flights = spark.read.csv('flights.csv',
                         sep=',',
                         header=True,
                         inferSchema=True,
                         nullValue='NA')

# Get number of records
print("The data contain %d records." % flights.count())

# View the first five records
flights.show(5)

# Check column data types
print(flights.dtypes)

# 2. Loading SMS spam data
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

# Specify column names and types
schema = StructType([
    StructField("id", IntegerType()),
    StructField("text", StringType()),
    StructField("label", IntegerType())
])

# Load data from a delimited file
sms = spark.read.csv('sms.csv', sep=';', header=False, schema=schema)

# Print schema of DataFrame
sms.printSchema()
