'''
Working with image processing can be tricky. As colour images can take the form of 3-D shapes, greyscale images are seen as 2-D, 
this creates the challenge or understanding how much extra information is contained within an image. To make it easier to switch 
between image types the following function was shared:

Pixels in an image range from 0 to 255. With 0 being pure black and 255 being pure white. The representation of these pixels 
values can be analysed using histograms

colours can be extracted from a 3d numpy array as follows:
red = [:, :, 0]
green = [:, :, 1]
blue = [:, :, 2]
'''

# Show an image using matplotlib.pyplot
import matplotlib.pyplot as plt

def show_image(image, title="Image", cmap_type="gray"):
  plt.imshow(image, cmap=cmap_type)
  plt.title(title)
  plt.axis('off')
  plt.show()
