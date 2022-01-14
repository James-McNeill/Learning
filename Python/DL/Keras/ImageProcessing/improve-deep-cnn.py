# Understanding and improving deep learning CNN
# we will focus on our ability to track how well a network is doing, and explore approaches towards improving convolutional neural networks.

# A. Tracking learning
# 1. Plot learning curves
# Note that the more epochs used for training then the val_loss will begin to increase again as the model starts to overfit the data
import matplotlib.pyplot as plt

# Train the model and store the training object
training = model.fit(train_data, train_labels, validation_split=0.20, epochs=3, batch_size=10)

# Extract the history from the training object
history = training.history

# Plot the training loss 
plt.plot(history['loss'])
# Plot the validation loss
plt.plot(history['val_loss'])

# Show the figure
plt.show()

# 2. Using stored weights to predict
# Load the weights from file
model.load_weights('weights.hdf5')

# Predict from the first three images in the test data
model.predict(test_data[:3])

# 3. Storing the optimal parameters
from keras.callbacks import ModelCheckpoint
# This checkpoint object will store the model parameters in the file "weights.hdf5"
checkpoint = ModelCheckpoint('weights.hdf5', monitor='val_loss',
                             save_best_only=True) # the model with the lowest val_loss will be stored
# Store in a list to be used during training
callbacks_list = [checkpoint]
# Fit the model on a training set, using the checkpoint as a callback
model.fit(train_data, train_labels, validation_split=0.2,           
          epochs=3, callbacks=callbacks_list)

# B. Regularization
# 1. Adding a dropout to the CNN
# Dropout is a form of regularization that removes a different random subset of the units in a layer in each round of training
# Add a convolutional layer
model.add(Conv2D(15, kernel_size=2, activation='relu', 
                 input_shape=(img_rows, img_cols, 1)))

# Add a dropout layer
model.add(Dropout(0.20))

# Add another convolutional layer
model.add(Conv2D(5, kernel_size=2, activation='relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# 2. Batch Normalization
# Aim is to rescale the outputs
# Add a convolutional layer
model.add(Conv2D(15, kernel_size=2, activation='relu',
    input_shape=(img_rows, img_cols, 1)
))

# Add batch normalization layer
model.add(BatchNormalization())

# Add another convolutional layer
model.add(Conv2D(5, kernel_size=2, activation='relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# C. Interpreting the model
# 1. Extracting a kernel from a trained network
# Load the weights into the model
model.load_weights('weights.hdf5')

# Get the first convolutional layer from the model
c1 = model.layers[0]

# Get the weights of the first convolutional layer
weights1 = c1.get_weights()

# Pull out the first channel of the first kernel in the first layer
kernel = weights1[0][...,0, 0]
print(kernel)
