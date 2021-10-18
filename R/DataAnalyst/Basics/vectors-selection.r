# Vector selection operations
# Note that R begins indexing from 1, instead of 0.

# Poker and roulette winnings from Monday to Friday:
poker_vector <- c(140, -50, 20, -120, 240)
roulette_vector <- c(-24, -50, 100, -350, 10)
days_vector <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
names(poker_vector) <- days_vector
names(roulette_vector) <- days_vector

# Define a new variable based on a selection - select one element of the vector
poker_wednesday <- poker_vector[3]

# Define a new variable based on a selection - select combination of elements
poker_midweek <- poker_vector[c(2, 3, 4)]
