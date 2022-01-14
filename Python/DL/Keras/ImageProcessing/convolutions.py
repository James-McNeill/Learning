# Using convolutions

# Convolutions are the fundamental building blocks of convolutional neural networks. 
# Will work to understand how convolutions can search for changes in elements of the image.

# A. Convolutions
# 1. One dimensional convolutions
array = np.array([1, 0, 1, 0, 1, 0, 1, 0, 1, 0])
kernel = np.array([1, -1, 0])
conv = np.array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

# Output array
for ii in range(8):
    conv[ii] = (kernel * array[ii:ii+3]).sum()

# Print conv. Reviews when the array values switch
print(conv)

# 2. Image convolutions
kernel = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]])
result = np.zeros(im.shape)

# Output array
for ii in range(im.shape[0] - 3):
    for jj in range(im.shape[1] - 3):
        result[ii, jj] = (im[ii:ii+3, jj:jj+3] * kernel).sum()

# Print result
print(result)

# 3. Defining image convolution kernels
# Searching for a vertical line in images
kernel = np.array([[-1, 1, -1], 
                  [-1, 1, -1], 
                  [-1, 1, -1]])

# Searching for a horizontal line in images
kernel = np.array([[-1, -1, -1], 
                   [1, 1, 1],
                   [-1, -1, -1]])

# Finds a light spot surrounded by dark pixels
kernel = np.array([[-1, -1, -1], 
                   [-1, 1, -1],
                   [-1, -1, -1]])

# Finds a dark spot surrounded by bright pixels
kernel = np.array([[1, 1, 1], 
                   [1, -1, 1],
                   [1, 1, 1]])

# B. Implementing image convolutions in Keras
# 1. Convolutional network for image classification
# Import the necessary components from Keras
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten

# Initialize the model object
model = Sequential()

# Add a convolutional layer
model.add(Conv2D(10, kernel_size=3, activation='relu', 
               input_shape=(img_rows, img_cols, 1)))

# Flatten the output of the convolutional layer
model.add(Flatten())
# Add an output layer for the 3 categories
model.add(Dense(3, activation='softmax'))

# 2. Training a CNN to classify clothing
# Compile the model 
model.compile(optimizer='adam', 
              loss='categorical_crossentropy', 
              metrics=['accuracy'])

# Fit the model on a training set
model.fit(train_data, train_labels, 
          validation_split=0.20, 
          epochs=3, batch_size=10)

# 3. Evaluate CNN
# Evaluate the model on separate test data
model.evaluate(test_data, test_labels, batch_size=10)

# C. Tweaking the convultions
# 1. Add padding to a CNN
# This is done by adding zeros around the edges of the input image, so that the convolution kernel can overlap with the pixels on the edge of the image
# Initialize the model
model = Sequential()

# Add the convolutional layer
model.add(Conv2D(10, kernel_size=3, activation='relu', 
                 input_shape=(img_rows, img_cols, 1), 
                 padding='same')) # insures that the size is the same as the input layer

# Feed into output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))

# 2. Add strides to CNN
# Size of the strides determines the size of the jump taken between each pixel as the kernel slides along
# Initialize the model
model = Sequential()

# Add the convolutional layer
model.add(Conv2D(10, kernel_size=3, activation='relu', 
              input_shape=(img_rows, img_cols, 1), 
              strides=2)) # the network skips every other pixel

# Feed into output layer
model.add(Flatten())
model.add(Dense(3, activation='softmax'))
