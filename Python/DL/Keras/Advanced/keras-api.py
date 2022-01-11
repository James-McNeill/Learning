# The keras functional API

# A. Keras input and dense layers
# 1. Input layers
# Input layer allows the model to load data
# Import Input from keras.layers
from keras.layers import Input

# Create an input layer of shape 1. As there is only one feature (column) within the input data
input_tensor = Input(shape=(1,))

