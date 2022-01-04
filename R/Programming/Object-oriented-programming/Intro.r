# Working with OOP

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
