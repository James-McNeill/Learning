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

