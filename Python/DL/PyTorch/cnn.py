# Convolutional Neural Networks

# OOP method
# Create 10 random images of shape (1, 28, 28)
images = torch.rand(10, 1, 28, 28)

# Build 6 conv. filters
conv_filters = torch.nn.Conv2d(in_channels=1, out_channels=6, kernel_size=3, stride=1, padding=1)

# Convolve the image with the filters 
output_feature = conv_filters(images)
print(output_feature.shape)

# Functional way
# Create 10 random images
image = torch.rand(10, 1, 28, 28)

# Create 6 filters
filters = torch.rand(6, 1, 3, 3)

# Convolve the image with the filters
output_feature = F.conv2d(image, filters, stride=1, padding=1)
print(output_feature.shape)

# Pooling operators
# Aims to reduce the size of an image to a lower dimension / resolution without losing too much information. By reducing the image size this makes the
# computations less intense.

# Max pooling
# Taking the maximum value from a section of the grid and keeping this value for the new grid of the original
# Build a pooling operator with size `2`.
max_pooling = torch.nn.MaxPool2d(2)

# Apply the pooling operator
output_feature = max_pooling(im)

# Use pooling operator in the image
output_feature_F = F.max_pool2d(im, 2)

# print the results of both cases. Same results are returned for each method. Choice of which is to use is left to the user
print(output_feature)
print(output_feature_F)

# Average pooling
# Build a pooling operator with size `2`.
avg_pooling = torch.nn.AvgPool2d(2)

# Apply the pooling operator
output_feature = avg_pooling(im)

# Use pooling operator in the image
output_feature_F = F.avg_pool2d(im, 2)

# print the results of both cases
print(output_feature)
print(output_feature_F)
