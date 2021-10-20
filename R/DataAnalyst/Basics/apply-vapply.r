# Working with vapply

# vapply(X, FUN, FUN.VALUE, ..., USE.NAMES = TRUE)
# FUN.VALUE: argument expects a template for the return argument of this function

# 1. Basic overview of the method
# Definition of basics()
basics <- function(x) {
  c(min = min(x), mean = mean(x), max = max(x))
}

# Apply basics() over temp using vapply() - returns matrix with the variable names outlined in the vector
vapply(temp, basics, numeric(3))

# 2. Additional method added to the function
# Definition of the basics() function
basics <- function(x) {
  c(min = min(x), mean = mean(x), median = median(x), max = max(x))
}

# Fix the error: initial value was 3 which matched the vapply from above, this caused an error as four methods are now present in the function
vapply(temp, basics, numeric(4))

# 3. Convert sapply to vapply methods
# temp is already defined in the workspace

# Convert to vapply() expression
sapply(temp, max)
vapply(temp, max, numeric(1))

# Convert to vapply() expression
sapply(temp, function(x, y) { mean(x) > y }, y = 5)
vapply(temp, function(x, y) { mean(x) > y }, y = 5, logical(1))
