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

# 2. Moving to parApply
# Determine the number of available cores
detectCores()

# Create a cluster via makeCluster
cl <- makeCluster(2)

# Parallelize this code. dd: relates to the DataFrame
parApply(cl, dd, 2, median)

# Stop the cluster
stopCluster(cl)
