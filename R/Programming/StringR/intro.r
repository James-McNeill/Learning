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

# 2. String length
library(stringr)
library(babynames)
library(dplyr)

# Extracting vectors for boys' and girls' names
babynames_2014 <- filter(babynames, year == 2014)
boy_names <- filter(babynames_2014, sex == "M")$name
girl_names <- filter(babynames_2014, sex == "F")$name

# Take a look at a few boy_names
head(boy_names)

# Find the length of all boy_names
boy_length <- str_length(boy_names)

# Take a look at a few lengths
head(boy_length)

# Find the length of all girl_names
girl_length <- str_length(girl_names)

# Find the difference in mean length
mean(girl_length) - mean(boy_length)

# Confirm str_length() works with factors
head(str_length(factor(boy_names)))

# 3. Extracting substrings
# Extract first letter from boy_names
boy_first_letter <- str_sub(boy_names, 1, 1)

# Tabulate occurrences of boy_first_letter
table(boy_first_letter)
  
# Extract the last letter in boy_names, then tabulate
boy_last_letter <- str_sub(boy_names, -1, -1)
table(boy_last_letter)

# Extract the first letter in girl_names, then tabulate
girl_first_letter <- str_sub(girl_names, 1, 1)
table(girl_first_letter)

# Extract the last letter in girl_names, then tabulate
girl_last_letter <- str_sub(girl_names, -1, -1)
table(girl_last_letter)

# str_sub() is similar to base R substr() function. Advantage of using str_sub() is the negative index values

# B. Hunting for matches
# 1. Detecting matches
# Look for pattern "zz" in boy_names
contains_zz <- str_detect(boy_names, pattern = "zz")

# Examine str() of contains_zz
str(contains_zz)

# How many names contain "zz"?
sum(contains_zz)

# Which names contain "zz"?
boy_names[contains_zz]

# Which rows in boy_df have names that contain "zz"?
boy_df[contains_zz,]

# 2. Subsetting strings based on match
# Find boy_names that contain "zz"
str_subset(boy_names, pattern = "zz")

# Find girl_names that contain "zz"
str_subset(girl_names, pattern = "zz")

# Find girl_names that contain "U"
starts_U <- str_subset(girl_names, pattern = "U")
starts_U

# Find girl_names that contain "U" and "z"
str_subset(starts_U, pattern = "z")

# 3. Counting matches
# Count occurrences of "a" in girl_names
number_as <- str_count(girl_names, pattern = "a")

# Count occurrences of "A" in girl_names
number_As <- str_count(girl_names, pattern = "A")

# Histograms of number_as and number_As
hist(number_as)
hist(number_As)

# Find total "a" + "A"
total_as <- number_as + number_As

# girl_names with more than 4 a's
girl_names[total_as > 4]
