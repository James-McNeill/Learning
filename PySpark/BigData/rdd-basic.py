# List of basic transformations and actions

# Basic RDD transformations:
# map(): applies function to all elements in an RDD
# filter(): returns new RDD with elements that match filter condition
# flatMap(): returns multiple values for each element in the original RDD
# union(): combines RDD's together to create a new RDD

# Create map() transformation to cube numbers
cubedRDD = numbRDD.map(lambda x: x ** 3)

# Collect the results
numbers_all = cubedRDD.collect()

# Print the numbers from numbers_all
for numb in numbers_all:
	print(numb)

# Basic RDD actions:
# collect(): return all elements of the dataset as an array
# take(N): returns an array with the first N elements of the dataset
# first(): prints the first element of the RDD
# count(): returns the number of elements in the RDD

# Filter the fileRDD to select lines with Spark keyword
fileRDD_filter = fileRDD.filter(lambda line: 'Spark' in line)

# How many lines are there in fileRDD?
print("The total number of lines with the keyword Spark is", fileRDD_filter.count())

# Print the first four lines of fileRDD
for line in fileRDD_filter.take(4): 
  print(line)
