# Show the corners that are present within an image. Requires that the image be converted to gray scale
def show_image_with_corners(image, coords, title="Corners detected"):
  plt.imshow(image, interpolation='nearest', cmap='gray')
  plt.title(title)
  plt.plot(coords[:, 1], coords[:, 0], '+r', markersize=15)
  plt.axis('off')
  plt.show()
