def getFace(d):
  ''' Extracts the face rectangle from the image using the    
  coordinates of the detected.'''
  # X and Y starting points of the face rectangle    
  x, y  = d['r'], d['c']
  # The width and height of the face rectangle    
  width, height = d['r'] + d['width'],  d['c'] + d['height']
  # Extract the detected face    
  face= image[x:width, y:height]
  return face
