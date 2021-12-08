# Benchmarking code
# Before optimising code we have to ensure that there is an initial benchmark to work with

# A. R version
# Print the R version details using version
version

# Assign the variable major to the major component
major <- version$major

# Assign the variable minor to the minor component
minor <- version$minor

# B. Benchmarking
# 1. Comparing read times of CSV and RDS files
# How long does it take to read movies from CSV?
system.time(read.csv("movies.csv"))

# How long does it take to read movies from RDS? RDS is R's native format for storing single objects
system.time(readRDS("movies.rds"))

# 2. Elapsed time
# Load the microbenchmark package. Enables the user to compare time taken for multiple functions efficiently
library(microbenchmark)

# Compare the two functions
compare <- microbenchmark(read.csv("movies.csv"), 
                          readRDS("movies.rds"), 
                          times = 10)

# Print compare
compare

# C. How good is your machine?
# 1. DataCamp hardware
# Load the benchmarkme package
library("benchmarkme")

# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()
ram

# Assign the variable cpu to the cpu specs
cpu <- get_cpu()
cpu

# 2. Benchmark DataCamp's machine
# Run the io benchmark. Provides a comparison of the time taken to create a 5Mb file
res <- benchmark_io(runs = 1, size = 5)

# Plot the results
plot(res)
