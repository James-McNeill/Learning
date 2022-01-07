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
