# Code profiling
# Profiling helps you locate the bottlenecks in your code

# A. Code profiling
# 1. Profvis in action
# Load the data set
data(movies, package = "ggplot2movies") 

# Load the profvis package
library(profvis)

# Profile the following code with the profvis function
profvis ({
  # Load and select data
  comedies <- movies[movies$Comedy == 1, ]

  # Plot data of interest
  plot(comedies$year, comedies$rating)

  # Loess regression line
  model <- loess(rating ~ year, data = comedies)
  j <- order(comedies$year)
  
  # Add fitted line to the plot
  lines(comedies$year[j], model$fitted[j], col = "red")
})

# 2. Change the data frame to a matrix to help with performance
# Load the microbenchmark package
library(microbenchmark)

# The previous data frame solution is defined
# d() Simulates 6 dices rolls
d <- function() {
  data.frame(
    d1 = sample(1:6, 3, replace = TRUE),
    d2 = sample(1:6, 3, replace = TRUE)
  )
}

# Complete the matrix solution
m <- function() {
  matrix(sample(1:6, 6, replace = TRUE), ncol = 2)
}

# Use microbenchmark to time m() and d()
microbenchmark(
 data.frame_solution = d(),
 matrix_solution     = m()
)

# 3. Calculating row sums
# Example data
rolls

# Define the previous solution 
app <- function(x) {
    apply(x, 1, sum)
}

# Define the new solution
r_sum <- function(x) {
    rowSums(x)
}

# Compare the methods
microbenchmark(
    app_sol = app(rolls),
    r_sum_sol = r_sum(rolls)
)
