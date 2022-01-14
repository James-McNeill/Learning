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
