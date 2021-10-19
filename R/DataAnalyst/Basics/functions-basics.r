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
