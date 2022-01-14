# Image Processing With Neural Networks

# A. Intro to CNN
# Convolutional neural networks use the data that is represented in images to learn
# 1. Images as data: visualizations
# Import matplotlib
import matplotlib.pyplot as plt

# Load the image
data = plt.imread('bricks.png')

# Display the image
plt.imshow(data)
plt.show()

# 2. Changing images
# The last dimension of the data allows the user to interact with the Red Green Blue (RGB) dynamics of the image.
# If all three dimensions where set to 1 then the image would display a yellow colour
# Set the red channel in this part of the image to 1
data[:10, :10, 0] = 1

# Set the green channel in this part of the image to 0
data[:10, :10, 1] = 0

# Set the blue channel in this part of the image to 0
data[:10, :10, 2] = 0

# Visualize the result
plt.imshow(data)
plt.show()

# B. Classifying images
# Providing the algorithm with labels allows it to learn which features to train for
# 1. Using one-hot encoding to represent images
# The number of image categories
n_categories = 3

# The unique values of categories in the data
categories = np.array(["shirt", "dress", "shoe"])

# Initialize ohe_labels as all zeros. Creates the 2D array to map each row and column
ohe_labels = np.zeros((len(labels), n_categories))

# Loop over the labels
for ii in range(len(labels)):
    # Find the location of this label in the categories variable
    jj = np.where(categories == labels[ii])
    # Set the corresponding zero to one
    ohe_labels[ii, jj] = 1

# 2. Evaluating a classifier
# Model was used to predict labels for the test dataset
# Calculate the number of correct predictions
number_correct = np.sum(test_labels * predictions)
print(number_correct)

# Calculate the proportion of correct predictions
proportion_correct = number_correct / len(predictions)
print(proportion_correct)

# C. Classification with keras
# 1. Build a neural network
# Creating a neural network with Dense layers, means that each unit in each layer is connected to all of the units in the previous layer
# Imports components from Keras
from keras.models import Sequential
from keras.layers import Dense

# Initializes a sequential model
model = Sequential()

# First layer. Input shape is the product of the pixel image size (28, 28) 
model.add(Dense(10, activation="relu", input_shape=(784,)))

# Second layer
model.add(Dense(10, activation="relu"))

# Output layer
model.add(Dense(3, activation="softmax"))

# 2. Compile a NN
# Compile the model
model.compile(optimizer='adam', 
           loss='categorical_crossentropy', 
           metrics=['accuracy'])

