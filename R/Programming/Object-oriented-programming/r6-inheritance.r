# R6 inheritance

# A. Functionality with inheritance
# 1. Specifying a Fancy Microwave Oven
# Inheritance is used to propagate – that is, copy – functionality from one class to another

# Explore the microwave oven class
microwave_oven_factory

# Define a fancy microwave class inheriting from microwave oven
fancy_microwave_oven_factory <- R6Class(
    "FancyMicrowaveOven",
    inherit = microwave_oven_factory
)

# 2. Making a fancy microwave oven
# Explore microwave oven classes
microwave_oven_factory
fancy_microwave_oven_factory

# Instantiate both types of microwave
a_microwave_oven <- microwave_oven_factory$new()
a_fancy_microwave <- fancy_microwave_oven_factory$new()

# Get power rating for each microwave
microwave_power_rating <- a_microwave_oven$power_rating_watts
fancy_microwave_power_rating <-a_fancy_microwave$power_rating_watts

# Verify that these are the same. Returns TRUE
identical(microwave_power_rating, fancy_microwave_power_rating)

# Cook with each microwave. Return the same output as the method was inherited
a_microwave_oven$cook(1)
a_fancy_microwave$cook(1)

# B. Embrace, Extend, Override
# 1. Extending the cooking
# Explore microwave oven class
microwave_oven_factory

# Extend the class definition
fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory,
  # Add a public list with a cook baked potato method
  public = list(
    cook_baked_potato = function() {
      self$cook(3)  # Applying this takes the inherited method. Using super$ would take the parent class method
    }
  )
)

# Instantiate a fancy microwave
a_fancy_microwave <- fancy_microwave_oven_factory$new()

# Call the cook_baked_potato() method
a_fancy_microwave$cook_baked_potato()

# 2. Override the cooking
# Explore microwave oven class
microwave_oven_factory

# Update the class definition
fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory,
  # Add a public list with a cook method. By assigning the method the same name we are overriding the inherited method from the parent class
  public = list(
    cook = function(time_seconds) {
      super$cook(time_seconds)
      message("Enjoy your dinner!")
    }
  )
)

# Instantiate a fancy microwave
a_fancy_microwave <- fancy_microwave_oven_factory$new()

# Call the cook() method
a_fancy_microwave$cook(1)
