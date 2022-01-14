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
