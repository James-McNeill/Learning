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

# B. Cloning R6 objects
# 1. Attack of the clones
# Create a microwave oven
a_microwave_oven <- microwave_oven_factory$new()

# Copy a_microwave_oven using <-
assigned_microwave_oven <- a_microwave_oven
  
# Copy a_microwave_oven using clone()
cloned_microwave_oven <- a_microwave_oven$clone()
  
# Change a_microwave_oven's power level  
a_microwave_oven$power_level_watts <- 400
  
# Check a_microwave_oven & assigned_microwave_oven same. Returns true, as there was a copy by reference
identical(a_microwave_oven, assigned_microwave_oven)

# Check a_microwave_oven & cloned_microwave_oven different. Returns false, as the clone insured copy by value for the cloned object
identical(a_microwave_oven, cloned_microwave_oven)  

# 2. Attack of the clones (2)
# If an R6 object contains another R6 object in one or more of its fields, then by default clone() will copy the R6 fields by reference. 
# To copy those R6 fields by value, the clone() method must be called with the argument deep = TRUE
# Create a microwave oven
a_microwave_oven <- microwave_oven_factory$new()

# Look at its power plug
a_microwave_oven$power_plug

# Copy a_microwave_oven using clone(), no args
cloned_microwave_oven <- a_microwave_oven$clone()
  
# Copy a_microwave_oven using clone(), deep = TRUE
deep_cloned_microwave_oven <- a_microwave_oven$clone(deep = TRUE)
  
# Change a_microwave_oven's power plug type  
a_microwave_oven$power_plug$type <- "British"
  
# Check a_microwave_oven & cloned_microwave_oven same 
identical(a_microwave_oven$power_plug$type, cloned_microwave_oven$power_plug$type)

# Check a_microwave_oven & deep_cloned_microwave_oven different 
identical(a_microwave_oven$power_plug$type, deep_cloned_microwave_oven$power_plug$type)  

# C. Shutting down connections
# 1. Closing the R6 object correctly
library(RSQLite) # Enables connection to SQLite databases within R
# Microwave_factory is predefined
microwave_oven_factory

# Complete the class definition
smart_microwave_oven_factory <- R6Class(
  "SmartMicrowaveOven",
  inherit = microwave_oven_factory, # Specify inheritance
  private = list(
    # Add a field to store connection
    conn = NULL
  ),
  public = list(
    initialize = function() {
      # Connect to the database
      private$conn = dbConnect(SQLite(), "cooking-times.sqlite")
    },
    get_cooking_time = function(food) {
      dbGetQuery(
        private$conn,
        sprintf("SELECT time_seconds FROM cooking_times WHERE food = '%s'", food)
      )
    },
    finalize = function() {
      # Print a message
      message("Disconnecting from the cooking times database.")
      # Disconnect from the database
      dbDisconnect(private$conn)
    }
  )
)

# Create a smart microwave object
a_smart_microwave <- smart_microwave_oven_factory$new()
  
# Call the get_cooking_time() method
a_smart_microwave$get_cooking_time("soup")

# Remove the smart microwave
rm(a_smart_microwave) 

# Force garbage collection
gc()
