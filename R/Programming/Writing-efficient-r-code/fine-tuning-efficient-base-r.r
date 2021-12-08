# R is flexible because you can often solve a single problem in many different ways. 
# Some ways can be several orders of magnitude faster than the others.

# A. Memory allocation
# 1. Timings - growing a vector
# One of the deadly R sins, you should never grow a vector
# Slow code
growing <- function(n) {
    x <- NULL
    for(i in 1:n)
        x <- c(x, rnorm(1))
    x
}

# Use <- with system.time() to store the result as res_grow
system.time(res_grow <- growing(n = 30000))

# 2. Timings - pre-allocation
# Fast code
pre_allocate <- function(n) {
    x <- numeric(n) # Pre-allocate
    for(i in 1:n) 
        x[i] <- rnorm(1)
    x
}

# Use <- with system.time() to store the result as res_allocate
n <- 30000
system.time(res_allocate <- pre_allocate(n))

# B. Importance of vectorizing the code
# 1. multiplication
# Slower for loop code
x <- rnorm(10)
x2 <- numeric(length(x))
for(i in 1:10)
    x2[i] <- x[i] * x[i]

# Vectorized version
# Store your answer as x2_imp
x2_imp <- x * x

# 2. calculating a log-sum
# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n) 
    total <- total + log(x[i])

# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))

# C. DataFrames and matrices
# 1. Column selection
# Which is faster, mat[, 1] or df[, 1]? As all values in a matrix have to contain the same data type, the matrix processing is much quicker.
# If either option can be picked, the matrix process will always be faster
microbenchmark(mat[, 1], df[, 1])

# 2. Row timings
# Which is faster, mat[1, ] or df[1, ]? As multiple data types can exist for a Data Frame with each column, this process will take longer
microbenchmark(mat[1, ], df[1, ])
