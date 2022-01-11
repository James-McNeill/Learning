# The keras functional API

# A. Keras input and dense layers
# 1. Input layers
# Input layer allows the model to load data
# Import Input from keras.layers
from keras.layers import Input

# Create an input layer of shape 1. As there is only one feature (column) within the input data
input_tensor = Input(shape=(1,))

# 2. Dense layers
# Load layers
from keras.layers import Input, Dense

# Input layer
input_tensor = Input(shape=(1,))

# Dense layer
output_layer = Dense(1)

# Connect the dense layer to the input_tensor
output_tensor = output_layer(input_tensor)

# 3. Output layers
# Output layers are simply dense layers. Output layers are used to reduce the dimension of the inputs.
# The output layers allow us to make model predictions
# Load layers
from keras.layers import Input, Dense

# Input layer
input_tensor = Input(shape=(1,))

# Create a dense layer and connect the dense layer to the input_tensor in one step
# Note that we did this in 2 steps in the previous exercise, but are doing it in one step now
output_tensor = Dense(1)(input_tensor)

# B. Build and compile a model
# 1. Build a model
# Input/dense/output layers
from keras.layers import Input, Dense
input_tensor = Input(shape=(1,))
output_tensor = Dense(1)(input_tensor)

# Build the model
from keras.models import Model
model = Model(input_tensor, output_tensor)

# 2. Compile a model
# Ensures that the settings are locked in
# Compile the model
model.compile(optimizer="adam", loss="mean_absolute_error")
