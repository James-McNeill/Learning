# Selecting elements from a list

# Build shining_list
shining_list <- list(moviename = mov, actors = act, reviews = rev)

# Print out the vector representing the actors
shining_list[["actors"]]
# alternative is shining_list$actors

# Print the second element of the vector representing the actors
shining_list$actors[2]
# alternative is shining_list[["actors"]][2]
