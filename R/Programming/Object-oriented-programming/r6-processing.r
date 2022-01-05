# R6 processes
# Learn how to define R6 classes, and to create R6 objects. You'll also learn about the structure of R6 classes, 
# and how to separate the user interface from the implementation details

# A. The object factory
# To create R6 objects, you first have to create a class generator, sometimes known as a factory. These are created using the R6Class() function
# Creating an R6 class template
library(R6)
thing_factory <- R6Class(
  "Thing",
  private = list(
    a_field = "a value",
    another_field = 123
  )
)

# 1. Specifying the microwave oven class
# Define microwave_oven_factory. First argument created is the class name which is in Upper camel case.
# Another argument to R6Class() is called private and holds the data fields for the object. This argument should be a list, with names for each of its elements.
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800
  )
)

# 2. Making microwave ovens
# View the microwave_oven_factory
microwave_oven_factory

# Make a new microwave oven. The new method doesn't need to be defined when it is being created
microwave_oven <- microwave_oven_factory$new()

# B. Hiding complexity with Encapsulation
# The third argument to R6Class() is called public and holds the user-facing functionality for the object. This argument should be a list, with names for each of its elements.
# The public element of an R6 class contains the functionality available to the user. Usually it will only contain functions
# 1. Learning to cook
# Add a cook method to the factory definition
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800
  ),
  public = list(
    cook = function(time_seconds) {
      Sys.sleep(time_seconds)
      print("Your food is cooked!")
    }
  )
)

# Create microwave oven object
a_microwave_oven <- microwave_oven_factory$new()

# Call cook method for 1 second
a_microwave_oven$cook(1)

# 2. Close the door
# prefix private$ allows us to use the items within the private list
# prefix self$ allows us to use the items within the public list
# Add a close_door() method
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800,
    door_is_open = FALSE
  ),
  public = list(
    cook = function(time_seconds) {
      Sys.sleep(time_seconds)
      print("Your food is cooked!")
    },
    open_door = function() {
      private$door_is_open <- TRUE
    },
    close_door = function() {
      private$door_is_open <- FALSE
    }
  )
)

# 3. First thing's first
# One special public method called initialize()
# initialize() lets you set the values of the private fields when you create an R6 object
# Add an initialize method
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800,
    door_is_open = FALSE
  ),
  public = list(
    cook = function(time_seconds) {
      Sys.sleep(time_seconds)
      print("Your food is cooked!")
    },
    open_door = function() {
      private$door_is_open <- TRUE
    },
    close_door = function() {
      private$door_is_open <- FALSE
    },
    # Add initialize() method here
    initialize = function(power_rating_watts, door_is_open) {
      if(!missing(power_rating_watts)) {
        private$power_rating_watts <- power_rating_watts
      }
      if(!missing(door_is_open)) {
        private$door_is_open <- door_is_open
      }
    }
  )
)

# Make a microwave
a_microwave_oven <- microwave_oven_factory$new(650, TRUE)

# C. Getting and setting with active bindings
# 1. Read the rating
# Add a binding for power rating
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    ..power_rating_watts = 800
  ),
  active = list(
    # Add the binding here. Allows the user to read the rating value
    power_rating_watts = function() {
      private$..power_rating_watts
    }
  )
)

# Make a microwave 
a_microwave_oven <- microwave_oven_factory$new()

# Get the power rating
a_microwave_oven$power_rating_watts

# 2. Control the power
# Allows the user to set private fields in a controlled way
# Add a binding for power rating
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    ..power_rating_watts = 800,
    ..power_level_watts = 800
  ),
  # Add active list containing an active binding
  active = list(
    power_level_watts = function(value) {
      if(missing(value)) {
        # Return the private value
        return (private$..power_level_watts)
      } else {
        # Assert that value is a number
        assert_is_a_number(value)
        # Assert that value is in a closed range from 0 to power rating
        assert_all_are_in_closed_range(value, 0, private$..power_rating_watts)
        # Set the private power level to value
        private$..power_level_watts <- value
      }
    }
  )
)

# Make a microwave 
a_microwave_oven <- microwave_oven_factory$new()

# Get the power level
a_microwave_oven$power_level_watts

# Try to set the power level to "400"
a_microwave_oven$power_level_watts <- "400"

# Try to set the power level to 1600 watts
a_microwave_oven$power_level_watts <- 1600

# Set the power level to 400 watts
a_microwave_oven$power_level_watts <- 400
