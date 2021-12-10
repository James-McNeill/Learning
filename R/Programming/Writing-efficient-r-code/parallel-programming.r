# Parallel programming

# A. CPUs
# By default R uses 1 core when processing
# 1. Check for number of cores
# Load the parallel package
library(parallel)

# Store the number of cores in the object no_of_cores
no_of_cores <- detectCores()

# Print no_of_cores
no_of_cores

