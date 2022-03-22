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
        
# B. Looping using the .apply() function
# 1. .apply() function in every cell
# Define the lambda transformation
get_square = lambda x: x**2

# Apply the transformation
data_sum = poker_hands.apply(get_square)
print(data_sum.head())

# 2. .apply() for rows iteration
# Define the lambda transformation
get_variance = lambda x: np.var(x)

# Apply the transformation
data_tr = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].apply(get_variance, axis=1)
print(data_tr.head())

# Apply the transformation - implement on each rank
data_tr = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].apply(get_variance, axis=0)
print(data_tr.head())
