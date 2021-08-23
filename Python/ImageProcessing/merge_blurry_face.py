# Blur over the face that is present within an image. Using the x and y starting co-ordinates
# combined with the height and width of the image
def mergeBlurryFace(original, gaussian_image):
  # X and Y starting points of the face rectangle    
  x, y  = d['r'], d['c']
  # The width and height of the face rectangle    
  width, height = d['r'] + d['width'],  d['c'] + d['height']    
  original[ x:width, y:height] =  gaussian_image
  return original
