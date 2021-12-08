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
