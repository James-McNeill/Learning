# Classify the data to prepare before modelling

# 1. Label the data
# Import the lit function
from pyspark.sql.functions import lit

# Select the rows where endword is 'him' and label 1
df_pos = df.where("endword = 'him'")\
           .withColumn('label', lit(1))

# Select the rows where endword is not 'him' and label 0
df_neg = df.where("endword <> 'him'")\
           .withColumn('label', lit(0))

# Union pos and neg in equal number
df_examples = df_pos.union(df_neg.limit(df_pos.count()))
print("Number of examples: ", df_examples.count())
df_examples.where("endword <> 'him'").sample(False, .1, 42).show(5)
