# Using convolutions

# Convolutions are the fundamental building blocks of convolutional neural networks. Will work to understand

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

