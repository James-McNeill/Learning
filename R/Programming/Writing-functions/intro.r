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
