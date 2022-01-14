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
