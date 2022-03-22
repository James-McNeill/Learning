# Selecting columns and rows efficiently
# This chapter will give you an overview of why efficient code matters and selecting specific and random rows and columns efficiently.

# A. The need for efficient coding I
# 1. Measuring time



# Calculate the result of the problem using formula() and print the time required
N = 1000000
fm_start_time = time.time()
first_method = formula(N)
print("Time using formula: {} sec".format(time.time() - fm_start_time))

# Calculate the result of the problem using brute_force() and print the time required
sm_start_time = time.time()
second_method = brute_force(N)
print("Time using the brute force: {} sec".format(time.time() - sm_start_time))
