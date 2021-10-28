# Working with User Defined Functions (UDFs)

# Import modules
import pyspark.sql.functions as F
from pyspark.sql.types import *

# 1. Define and use UDF
# Define function
def getFirstAndMiddle(names):
  # Return a space separated string of names
  return ' '.join(names[:-1])

# Define the method as a UDF. Have to assign the function to an output type defined by the return value from the function
udfFirstAndMiddle = F.udf(getFirstAndMiddle, StringType())

# Create a new column using your UDF. After assigning the function then it can be used
voter_df = voter_df.withColumn('first_and_middle_name', udfFirstAndMiddle(voter_df.splits))

# Show the DataFrame
voter_df.show()
