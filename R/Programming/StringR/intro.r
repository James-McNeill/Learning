# Introduction to stringr

# A. Intro
# 1. Putting strings together with stringr
# For your first stringr function, we'll look at str_c(), the c is short for concatenate, a function that works like paste(). 
# It takes vectors of strings as input along with sep and collapse arguments.
library(stringr)

my_toppings <- c("cheese", NA, NA)
my_toppings_and <- paste(c("", "", "and "), my_toppings, sep = "")

# Print my_toppings_and
my_toppings_and

# Use str_c() instead of paste(): my_toppings_str
my_toppings_str <- str_c(c("", "", "and "), my_toppings)

# Print my_toppings_str
my_toppings_str

# paste() my_toppings_and with collapse = ", "
paste(my_toppings_and, collapse = ", ")

# str_c() my_toppings_str with collapse = ", "
str_c(my_toppings_str, collapse = ", ")

# another stringr function str_replace_na() can be used to replace missing values with any string choosen
