# Visualising the aesthetics

# A. Visible aesthetics
# 1. Color, shape and size attributes
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Set the shape and size of the points
  geom_point(shape = 1, size = 4)
