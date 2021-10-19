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

# 2. Function with no parameters
# Define the function hello()
hello <- function() {
    print("Hi there!")
    return (TRUE)
}

# Call the function hello()
hello()

# 3. Adding in default keyword parameters
# Finish the pow_two() function
pow_two <- function(x, print_info = TRUE) {
  y <- x ^ 2
  if (print_info == TRUE) {
    print(paste(x, "to the power two equals", y))
  }
  return(y)
}

# 4. Define control flow constructs
# The linkedin and facebook vectors have already been created for you

# Define the interpret function
interpret <- function(num_views) {
  if (num_views > 15) {
    print("You're popular!")
    return (num_views)
  } else {
    print("Try to be more visible!")
    return (0)
  }
}

# Call the interpret function twice
interpret(linkedin[1])
interpret(facebook[2])

# 5. Combining functions to return results
# The linkedin and facebook vectors have already been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

# The interpret() can be used inside interpret_all()
interpret <- function(num_views) {
  if (num_views > 15) {
    print("You're popular!")
    return(num_views)
  } else {
    print("Try to be more visible!")
    return(0)
  }
}

# Define the interpret_all() function
# views: vector with data to interpret
# return_sum: return total number of views on popular days?
interpret_all <- function(views, return_sum = TRUE) {
  count <- 0

  for (v in views) {
    count <- count + interpret(v)
  }

  if (return_sum) {
    return (count)
  } else {
    return (NULL)
  }
}

# Call the interpret_all() function on both linkedin and facebook
interpret_all(linkedin)
interpret_all(facebook)
