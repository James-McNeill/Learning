# Selecting columns and rows efficiently
# This chapter will give you an overview of why efficient code matters and selecting specific and random rows and columns efficiently.

# A. The need for efficient coding I
# 1. Measuring time I

# Extract the syntax for the functions that were used
import inspect
print(inspect.getsource(formula))

# Efficient formula function
def formula(N):
    return N*(N+1)*(2*N+1)/6

# Brute force function
def brute_force(N):
    res = 0
    UL = N+1
    for i in range(1,UL):
        res+=i^2
    return res

# Calculate the result of the problem using formula() and print the time required
N = 1000000
fm_start_time = time.time()
first_method = formula(N)
print("Time using formula: {} sec".format(time.time() - fm_start_time))

# Calculate the result of the problem using brute_force() and print the time required
sm_start_time = time.time()
second_method = brute_force(N)
print("Time using the brute force: {} sec".format(time.time() - sm_start_time))

# 2. Measuring time II
# Comparison between the list comprehension and for loop methods. If the analysis was performed on a much larger dataset
# then there could have been a larger time difference due to algorithm efficiency. Overall the list comprehension should
# provide the most efficient method 
# Store the time before the execution
start_time = time.time()

# Execute the operation
letlist = [wrd for wrd in words if wrd.startswith('b')]

# Store and print the difference between the start and the current time
total_time_lc = time.time() - start_time
print('Time using list comprehension: {} sec'.format(total_time_lc))

# Store the time before the execution
start_time = time.time()

# Execute the operation
letlist = []
for wrd in words:
    if wrd.startswith('b'):
        letlist.append(wrd)
        
# Print the difference between the start and the current time
total_time_fl = time.time() - start_time
print('Time using for loop: {} sec'.format(total_time_fl))
