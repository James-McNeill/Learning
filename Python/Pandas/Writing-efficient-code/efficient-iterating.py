# Efficient iterating
# This chapter presents different ways of iterating through a Pandas DataFrame and why vectorization is the most efficient way to achieve it.

# A. Looping using the .iterrows() function
# 1. Create a generator for a pandas DataFrame
# Create a generator over the rows
generator = poker_hands.iterrows()

# Access the elements of the 2nd row
first_element = next(generator)
second_element = next(generator)
print(first_element, second_element)

# 2. The iterrows() function for looping
data_generator = poker_hands.iterrows()

for index, values in data_generator:
  	# Check if index is odd
    if index % 2 != 0:
      	# Sum the ranks of all the cards
        hand_sum = sum([values[1], values[3], values[5], values[7], values[9]])
        
# 3. 
