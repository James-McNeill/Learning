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

# B. Moving to parApply
# Determine the number of available cores
detectCores()

# Create a cluster via makeCluster
cl <- makeCluster(2)

# Parallelize this code. dd: relates to the DataFrame
parApply(cl, dd, 2, median)

# Stop the cluster
stopCluster(cl)

# C. Using parSapply
# play() function game
play <- function() {
  total <- no_of_rolls <- 0
  while(total < 10) {
    total <- total + sample(1:6, 1)

    # If even. Reset to 0
    if(total %% 2 == 0) total <- 0 
    no_of_rolls <- no_of_rolls + 1
  }
  no_of_rolls
}

library("parallel")
# Create a cluster via makeCluster (2 cores)
cl <- makeCluster(2)

# Export the play() function to the cluster. Makes it easier to work with the function in a cluster
clusterExport(cl, "play")

# Re-write sapply as parSapply
res <- parSapply(cl, 1:100, function(i) play())

# Stop the cluster
stopCluster(cl)
