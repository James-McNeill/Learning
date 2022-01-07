# Advanced R6

# A. Environments, Reference Behavior, & Shared Fields
# 1. Working with Environments
# Define a new environment
env <- new.env()
  
# Add an element named perfect
  env$perfect <- list(6, 28, 496) 

# Add an element named bases
  env[["bases"]] <- list("A", "C", "G", "T")

# 2. Working with Environments (2)
# Most types of R variable use "copy by value", meaning that when you take a copy of them, the new variable has its own copy of the values
# Environments use a different system, known as "copy by reference", so that all copies are identical; changing one copy changes all the copies
# Assign lst
lst <- list(
  perfect = c(6, 28, 496),
  bases = c("A", "C", "G", "T")
)

# Copy lst
lst2 <- lst
  
# Change lst's bases element
lst$bases <- c("A", "C", "G", "U")
  
# Test lst and lst2 identical
identical(lst$bases, lst2$bases)

# Assign lst and env
lst <- list(
  perfect = c(6, 28, 496),
  bases = c("A", "C", "G", "T")
)
env <- list2env(lst)

# Copy env
env2 <- env
  
# Change env's bases element
env$bases <- c("A", "C", "G", "U")
  
# Test env and env2 identical
identical(env$bases, env2$bases)

# 3. Static Electricity
# Complete the class definition
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    shared = {
      # Create a new environment named e
      e <- new.env()
      # Assign safety_warning into e
      e$safety_warning <- "Warning. Do not try to cook metal objects."
      # Return e
      e
    }
  ),
  active = list(
    # Add the safety_warning binding
    safety_warning = function(value) {
      if(missing(value)) {
        private$shared$safety_warning
      } else {
        private$shared$safety_warning <- value
      }
    }
  )
)

# Create two microwave ovens
a_microwave_oven <- microwave_oven_factory$new()
another_microwave_oven <- microwave_oven_factory$new()
  
# Change the safety warning for a_microwave_oven
a_microwave_oven$safety_warning <- "Warning. If the food is too hot you may scald yourself."
  
# Verify that the warning has change for another_microwave
another_microwave_oven$safety_warning
