# Import the modules from skimage
from skimage import data, color

# Load the rocket image
rocket = data.rocket()

# Convert the image to grayscale
gray_scaled_rocket = color.rgb2gray(rocket)

# Show the original image
show_image(rocket, 'Original RGB image')

# Show the grayscale image
show_image(gray_scaled_rocket, 'Grayscale image')

# Flip the image vertically
rocket_vertical_flip = np.flipud(rocket)

# Flip the image horizontally
rockey_horizontal_flip = np.fliplr(rocket_vertical_flip)

# Show the resulting image
show_image(rocket_horizontal_flip, 'Rocket')

# Obtain the red channel
red_channel = image[:, :, 0]

# Plot the red histogram with bins in a range of 256
plt.hist(red_channel.ravel(), bins=256)

# Set title and show
plt.title('Red Histogram')
plt.show()

# Pixels in an image range from 0 to 255. With 0 being pure black and 255 being pure white. The representation of these pixels values can be analysed using histograms

# colours can be extracted from a 3d numpy array as follows:
# red = [:, :, 0]
# green = [:, :, 1]
# blue = [:, :, 2]
