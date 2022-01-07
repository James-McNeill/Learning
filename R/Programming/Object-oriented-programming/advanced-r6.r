# Advanced R6

# A. Environments, Reference Behavior, & Shared Fields
# 1. Working with Environments
# Define a new environment
env <- new.env()
  
# Add an element named perfect
  env$perfect <- list(6, 28, 496) 

# Add an element named bases
  env[["bases"]] <- list("A", "C", "G", "T")
