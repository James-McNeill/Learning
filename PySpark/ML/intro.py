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

