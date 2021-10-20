# Working with apply functions - sapply

# use str(temp) to see structure of temp list with vectors

# 1. Difference between lapply and sapply outputs
# temp has already been defined in the workspace

# Use lapply() to find each day's minimum temperature - returns a list of values
lapply(temp, min)

# Use sapply() to find each day's minimum temperature - returns a vector of values
sapply(temp, min)

# Use lapply() to find each day's maximum temperature
lapply(temp, max)

# Use sapply() to find each day's maximum temperature
sapply(temp, max)

# 2. Using a user defined function
# temp is already defined in the workspace

# Finish function definition of extremes_avg
extremes_avg <- function(x) {
  ( min(x) + max(x) ) / 2
}

# Apply extremes_avg() over temp using sapply()
sapply(temp, extremes_avg)

# Apply extremes_avg() over temp using lapply()
lapply(temp, extremes_avg)
