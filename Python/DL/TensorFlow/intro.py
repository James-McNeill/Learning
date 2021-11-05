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
