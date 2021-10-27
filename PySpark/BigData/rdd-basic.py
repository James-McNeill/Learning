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
