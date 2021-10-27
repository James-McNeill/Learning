# Working with pair RDD's
# Pair RDD's relates to the idea that data in the wild is usally represented by key/value pairs

# Examples of paired RDD Transformations
# reduceByKey(func): Combine values with the same key
# groupByKey(): Group values with the same key
# sortByKey(): Return an RDD sorted by the key 
# join(): Join two pair RDDs based on their key

# Create PairRDD Rdd with key value pairs
Rdd = sc.parallelize([(1,2), (3,4), (3,6), (4,5)])

# Apply reduceByKey() operation on Rdd
Rdd_Reduced = Rdd.reduceByKey(lambda x, y: x + y)

# Iterate over the result and print the output
for num in Rdd_Reduced.collect(): 
  print("Key {} has {} Counts".format(num[0], num[1]))
