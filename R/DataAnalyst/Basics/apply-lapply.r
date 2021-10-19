# Working with lapply function

# lapply returns a list of the same length as X, each element of which is the result of applying FUN to the corresponding element of X.
# lapply(x, FUN)
# x: element to review
# FUN: function to apply to element(s)


# The vector pioneers has already been created for you
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")

# Split names from birth year
split_math <- strsplit(pioneers, split = ":")

# Convert to lowercase strings: split_low
split_low <- lapply(split_math, tolower)

# Take a look at the structure of split_low
str(split_low)
