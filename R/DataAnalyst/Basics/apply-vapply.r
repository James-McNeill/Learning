# Working with vapply

# vapply(X, FUN, FUN.VALUE, ..., USE.NAMES = TRUE)
# FUN.VALUE: argument expects a template for the return argument of this function

# 1. 
# Definition of basics()
basics <- function(x) {
  c(min = min(x), mean = mean(x), max = max(x))
}

# Apply basics() over temp using vapply() - returns matrix with the variable names outlined in the vector
vapply(temp, basics, numeric(3))
