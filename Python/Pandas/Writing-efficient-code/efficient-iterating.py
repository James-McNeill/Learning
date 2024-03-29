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

# C. Vectorization over pandas series
# 1. Pandas vectorization in action
# Calculate the mean rank in each hand
row_start_time = time.time()
mean_r = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].mean(axis=1)
print("Time using pandas vectorization for rows: {} sec".format(time.time() - row_start_time))
print(mean_r.head())

# Calculate the mean rank of each of the 5 card in all hands
col_start_time = time.time()
mean_c = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].mean(axis=0)
print("Time using pandas vectorization for columns: {} sec".format(time.time() - col_start_time))
print(mean_c.head())

# D. Vectorization with NumPy arrays using .values()
# 1. Vectorization methods for looping a DataFrame
# Calculate the variance in each hand
start_time = time.time()
poker_var = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].var(axis=1)
print("Time using pandas vectorization: {} sec".format(time.time() - start_time))
print(poker_var.head())

# Calculate the variance in each hand
start_time = time.time()
poker_var = poker_hands[['R1', 'R2', 'R3', 'R4', 'R5']].values.var(axis=1, ddof=1) # ddof: Delta Degrees of Freedom
print("Time using NumPy vectorization: {} sec".format(time.time() - start_time))
print(poker_var[0:5])
