# Working with lapply function

# lapply returns a list of the same length as X, each element of which is the result of applying FUN to the corresponding element of X.
# lapply(x, FUN)
# x: element to review
# FUN: function to apply to element(s)

# 1. Perform initial review
# The vector pioneers has already been created for you
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")

# Split names from birth year
split_math <- strsplit(pioneers, split = ":")

# Convert to lowercase strings: split_low
split_low <- lapply(split_math, tolower)

# Take a look at the structure of split_low
str(split_low)

# 2. Extract elements from the vector with two functions
# Code from previous exercise:
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)

# Write function select_first()
select_first <- function(x) {
  x[1]
}

# Apply select_first() over split_low: names
names <- lapply(split_low, select_first)

# Write function select_second()
select_second <- function(x) {
  x[2]
}

# Apply select_second() over split_low: years
years <- lapply(split_low, select_second)

# 3. Create and use anonymous function i.e. function not assigned to a variable
# split_low has been created for you
split_low

# Transform: use anonymous function inside lapply
function(x) {x[1]}
names <- lapply(split_low, function(x) {x[1]})

# Transform: use anonymous function inside lapply
function(x) {x[2]}
years <- lapply(split_low, function(x) {x[2]})

# 4. Use lapply with additional arguments - allows the creation of a generic function to be applied multiple times
# Definition of split_low
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)

# Generic select function
select_el <- function(x, index) {
  x[index]
}

# Use lapply() twice on split_low: names and years
names <- lapply(split_low, select_el, index = 1)
years <- lapply(split_low, select_el, index = 2)
