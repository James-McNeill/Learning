# Writing functions in R

# A. Why you should use functions?
# 1. Calling functions
# Look at the gold medals data
gold_medals

# Note the arguments to median()
args(median)

# Rewrite this function call, following best practices. For best practice, only require to outline less often used arguments
median(gold_medals, na.rm = TRUE)

# Note the arguments to rank()
args(rank)

# Rewrite this function call, following best practices. na.last = "keep", means keep the rank of NA values as NA
rank(-gold_medals, na.last = "keep", ties.method = "min")

# B. Converting scripts into functions
# 1. First function: tossing a coin
coin_sides <- c("head", "tail")

# Sample from coin_sides once
sample(coin_sides, 1)

# Write a template for your function, toss_coin()
toss_coin <- function() {
  # (Leave the contents of the body for later)
# Add punctuation to finish the body
}

# Your functions, from previous steps
toss_coin <- function() {
  coin_sides <- c("head", "tail")
  sample(coin_sides, 1)
}

# Call your function
toss_coin()

# 2. Providing input arguments to a function
# Update the function to return n coin tosses
toss_coin <- function(n_flips) {
  coin_sides <- c("head", "tail")
  sample(coin_sides, n_flips, replace = TRUE)
}

# Generate 10 coin tosses
toss_coin(10)

# 3. Multiple inputs to functions
# Update the function so heads have probability p_head. Additional elements added to function signature are separated by comma
toss_coin <- function(n_flips, p_head) {
  coin_sides <- c("head", "tail")
  # Define a vector of weights
  weights <- c(p_head, 1 - p_head)
  # Modify the sampling to be weighted
  sample(coin_sides, n_flips, replace = TRUE, prob = weights)
}

# Generate 10 coin tosses
toss_coin(10, 0.8)

# C. Renaming functions
# In order to allow for better readability, be careful with function naming convention
# 1. Renaming GLM
# Run a generalized linear regression 
glm(
  # Model no. of visits vs. gender, income, travel
  n_visits ~ gender + income + travel, 
  # Use the snake_river_visits dataset
  data = snake_river_visits, 
  # Make it a Poisson regression
  family = poisson
)

# Create the function to better apply the regression method
run_poisson_regression <- function(data, formula) {
  glm(formula, data, family = poisson)
}

# Re-run the Poisson regression, using your function. The pipe operation allows for the data to be passed through without explicitly calling it
model <- snake_river_visits %>%
  run_poisson_regression(n_visits ~ gender + income + travel)

# Run this to see the predictions
snake_river_explanatory %>%
  mutate(predicted_n_visits = predict(model, ., type = "response"))%>%
  arrange(desc(predicted_n_visits))
