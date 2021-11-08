# Building deep learning models with keras

# A. Creating a keras model
# 1. Specifying a model
# Import necessary modules
import keras
from keras.layers import Dense
from keras.models import Sequential

# Save the number of columns in predictors: n_cols
n_cols = predictors.shape[1]

# Set up the model: model
model = Sequential()

# Add the first layer.
# input_shape: n_cols items per row of data, and any number of rows of data are acceptable as inputs
model.add(Dense(50, activation='relu', input_shape=(n_cols,)))

# Add the second layer
model.add(Dense(32, activation='relu'))

# Add the output layer
model.add(Dense(1))

# 2. Compile the model
model.compile(optimizer='adam', loss='mean_squared_error')

# Verify that model contains information from compiling
print("Loss function: " + model.loss)

# 3. Fit the model
# Displays the model fit taking place and how the loss function output is being produced each time.
# epoch: relates to the number of times that the model trains through all of the data within the input file i.e. each time all of the rows (samples) have been
# reviewed when training the model for each hidden layer node
model.fit(predictors, target)
