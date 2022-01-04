# Working with OOP
# S3 and R6 are OOP frameworks related to R. Each of them relate to historic programming concepts for R

# A. What is it?
# 1. Dealing with objects
# Create these variables
a_numeric_vector <- rlnorm(50)
a_factor <- factor(
  sample(c(LETTERS[1:5], NA), 50, replace = TRUE)
)
a_data_frame <- data.frame(
  n = a_numeric_vector,
  f = a_factor
)
a_linear_model <- lm(dist ~ speed, cars)

# Call summary() on the numeric vector
summary(a_numeric_vector)

# Do the same for the other three objects
summary(a_factor)
summary(a_data_frame)
summary(a_linear_model)

# B. How does R distinguish variables?
# 1. What's my type
# function created to review the four functions that help to understand what type of variable that we are working with
type_of <- function(x)
{
  c(
    class = class(x), 
    typeof = typeof(x), 
    mode = mode(x), 
    storage.mode = storage.mode(x)
  )
}

# Look at the definition of type_info()
type_info

# Create list of example variables. Note that most functions that are used will be closure type
some_vars <- list(
  an_integer_vector = rpois(24, lambda = 5),
  a_numeric_vector = rbeta(24, shape1 = 1, shape2 = 1),
  an_integer_array = array(rbinom(24, size = 8, prob = 0.5), dim = c(2, 3, 4)),
  a_numeric_array = array(rweibull(24, shape = 1, scale = 1), dim = c(2, 3, 4)),
  a_data_frame = data.frame(int = rgeom(24, prob = 0.5), num = runif(24)),
  a_factor = factor(month.abb),
  a_formula = y ~ x,
  a_closure_function = mean,
  a_builtin_function = length,
  a_special_function = `if`
)

# Loop over some_vars calling type_info() on each element to explore them
lapply(some_vars, type_info)

# C. Assigning classes
# 1. Make if classy
# Explore the structure of chess
str(chess)

# Override the class of chess
class(chess) <- "chess_game"

# Is chess still a list? Yes the implicit type will stay the same
is.list(chess)

# How many pieces are left on the board?
length(unlist(chess))
