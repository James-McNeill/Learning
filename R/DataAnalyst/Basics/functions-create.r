# Creating functions

# Basic structure of a function
# my_fun <- function(arg1, arg2) {
#  body
# }

# my_fun: variable that is assigned the function
# function: method that is provided
# arg1, arg2: two positional parameter arguments used to define the function
# body: element of the function where an operation takes place

# 1. Create basic functions
# Create a function pow_two()
pow_two <- function(x) {
    x * x
}

# Use the function
pow_two(12)

# Create a function sum_abs()
sum_abs <- function(x, y) {
    abs(x) + abs(y)
}

# Use the function
sum_abs(-2, 3)
