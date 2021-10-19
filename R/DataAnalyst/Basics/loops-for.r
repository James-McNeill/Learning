# Loops - for
# Working with the for loop method

# 1. Basic for loop
# The linkedin vector has already been defined for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)

# Loop version 1
for (l in linkedin) {
    print(l)
}

# Loop version 2
for (l in 1:length(linkedin)) {
    print(linkedin[l])
}

# 2. Working with list
# The nyc list is already specified
nyc <- list(pop = 8405837, 
            boroughs = c("Manhattan", "Bronx", "Brooklyn", "Queens", "Staten Island"), 
            capital = FALSE)

# Loop version 1
for (n in nyc) {
    print(n)
}

# Loop version 2
for (n in 1:length(nyc)) {
    print(nyc[[n]])
}

# 3. Looping over matrix
# The tic-tac-toe matrix ttt has already been defined for you

# define the double for loop
for (i in 1:nrow(ttt)) {
  for (j in 1:ncol(ttt)) {
    print(paste("On row ", i, " and column ", j, " the board contains ", ttt[i, j]))
  }
}

# 4. Looping over vector with if statements
# The linkedin vector has already been defined for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)

# Code the for loop with conditionals
for (li in linkedin) {
  if (li > 10) {
    print("You're popular!")
  } else {
    print("Be more visible!")
  }
  print(li)
}
