# Building deeper CNN
# The term deep learning comes from this idea of building multiple layers to learn

# For an image multiple elements in the image need to be reviewed. Therefore, each deep learning layer is aiming to understand a different
# element of the image. Similar to drawing an image, different sections require a different process to complete and are processed in a multi-layered
# order. This is now the aim of building a deeper network to help follow different aspects with each layer

# Remember that as more layers are added to make the network deeper, more data is required to ensure that a broad range of data points (images) are
# classified to avoid overfitting.

# A. Going deeper
# 1. Creating a deep learning network
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten

model = Sequential()

# Add a convolutional layer (15 units)
model.add(Conv2D(15, kernel_size=2, activation='relu',
    input_shape=(img_rows, img_cols, 1)
))

# Add another convolutional layer (5 units). As the second convolution layer takes input from the previous layer it does not require an input shape parameter
model.add(Conv2D(5, kernel_size=2, activation='relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# 2. Train a deep learning model
# Compile model
model.compile(optimizer='adam', 
              loss='categorical_crossentropy', 
              metrics=['accuracy'])

# Fit the model to training data 
model.fit(train_data, train_labels, 
          validation_split=0.2, 
          epochs=3, batch_size=10)

# Evaluate the model on test data
model.evaluate(test_data, test_labels, batch_size=10)

# B. How many parameters
# 1. How many parameters in a deep CNN
# CNN model
model = Sequential()
model.add(Conv2D(10, kernel_size=2, activation='relu', 
                 input_shape=(28, 28, 1)))
model.add(Conv2D(10, kernel_size=2, activation='relu'))
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# Summarize the model 
model.summary()

# C. Pooling operations
# Pooling layers are often added between the convolutional layers of a neural network to summarize
# their outputs in a condensed manner, and reduce the number of parameters in the next layer in the network
# 1. Write a pooling operation
# Aim is to reduce the number of pixels that need to be processed from the image. This can help when training the model.
# The idea is to understand what level of reduction in pixel quality can take place but still retain the key elements
# from the image.
# Result placeholder
result = np.zeros((im.shape[0]//2, im.shape[1]//2))

# Pooling operation
for ii in range(result.shape[0]):
    for jj in range(result.shape[1]):
        result[ii, jj] = np.max(im[ii*2:ii*2+2,jj*2:jj*2+2])

# 2. Keras pooling layers
# Note the model is deeper than before but has fewer parameters
# Add a convolutional layer
model.add(Conv2D(15, kernel_size=2, activation='relu', 
                 input_shape=(img_rows, img_cols, 1)))

# Add a pooling operation
model.add(MaxPool2D(2))

# Add another convolutional layer
model.add(Conv2D(5, kernel_size=2, activation='relu'))

# Flatten and feed to output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))
model.summary()

# 3. Train the deep learning model
# Compile the model
model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

# Fit to training data
model.fit(train_data, train_labels, epochs=3, batch_size=10, validation_split=0.20)

# Evaluate on test data 
model.evaluate(test_data, test_labels, batch_size=10)
