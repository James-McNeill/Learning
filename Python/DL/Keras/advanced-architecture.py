# Working with advanced model architecture

# A. Tensors, layers and autoencoders
# 1. Tensors
# We are able to understand the calculations that take with layers contained within the model by specifying these layers and extracting the relevant
# input / output attributes. The K.function() can be used to complete the computations. Example used here is the banknotes model
# Import keras backend
import keras.backend as K

# Input tensor from the 1st layer of the model
inp = model.layers[0].input

# Output tensor from the 1st layer of the model
out = model.layers[0].output

# Define a function from inputs to outputs
inp_to_out = K.function([inp], [out])

# Print the results of passing X_test through the 1st layer
print(inp_to_out([X_test]))
