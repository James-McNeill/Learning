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
