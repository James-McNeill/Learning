# Working with the Keras API to train models

# A. Defining neural network using keras
# 1. The sequential model in Keras
# Define a Keras sequential model
model = keras.Sequential()

# Define the first dense layer
model.add(keras.layers.Dense(16, activation='relu', input_shape=(784,)))

# Define the second dense layer
model.add(keras.layers.Dense(8, activation='relu'))

# Define the output layer
model.add(keras.layers.Dense(4, activation='softmax'))

# Print the model architecture. This method allows us to see the model details prior to compiling
print(model.summary())
