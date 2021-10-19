# Basics of working with functions

# 1. Function documentation
# Consult the documentation on the mean() function
help(mean)
# ?mean

# Inspect the arguments of the mean() function
args(mean)

# 2. Calling a function
# The linkedin and facebook vectors have already been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

# Calculate average number of views
avg_li <- mean(linkedin)
avg_fb <- mean(facebook)

# Inspect avg_li and avg_fb
avg_li
avg_fb

# 3. Using an optional keyword parameter within the mean() function
# Calculate the mean of the sum
avg_sum <- mean(linkedin + facebook)

# Calculate the trimmed mean of the sum
avg_sum_trimmed <- mean(linkedin + facebook, trim = 0.2)

# Inspect both new variables
avg_sum
avg_sum_trimmed

# 4. Working with missing values parameter. The parameter na.rm relates to the missing values and whether
# they should be excluded when performing the calculations. By default the option is set to FALSE and missing
# values are included.
# The linkedin and facebook vectors have already been created for you
linkedin <- c(16, 9, 13, 5, NA, 17, 14)
facebook <- c(17, NA, 5, 16, 8, 13, 14)

# Basic average of linkedin - result is NA
mean(linkedin)

# Advanced average of linkedin - result is average of non missing values
mean(linkedin, na.rm = TRUE)
