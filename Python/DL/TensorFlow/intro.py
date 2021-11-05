# Introduction to TensorFlow

# A. Constants and Variables
# 1. Constants. Converting a numpy array containing credit card data to a TensorFlow constant
# Import constant from TensorFlow
from tensorflow import constant

# Convert the credit_numpy array into a tensorflow constant
credit_constant = constant(credit_numpy)

# Print constant datatype
print('\n The datatype is:', credit_constant.dtype)

# Print constant shape
print('\n The shape is:', credit_constant.shape)

# 2. Variables.
# Unlike a constant a variables value can be updated. This will be useful when working with parameter values that change over time
# Note that the Variable sub-module has been imported from TensorFlow already
# Define the 1-dimensional variable A1
A1 = Variable([1, 2, 3, 4])

# Print the variable A1
print('\n A1: ', A1)

# Convert A1 to a numpy array and assign it to B1
B1 = A1.numpy()

# Print B1
print('\n B1: ', B1)
