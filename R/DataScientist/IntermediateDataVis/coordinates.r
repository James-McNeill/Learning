# Coordinates 

# A. Coordinates
# 1. Zooming in
# Run the code, view the plot, then update it. Output will have errors due to not enough data being available
ggplot(mtcars, aes(x = wt, y = hp, color = fam)) +
  geom_point() +
  geom_smooth() +
  # Add a continuous x scale from 3 to 6
  scale_x_continuous(limits = c(3, 6))

# Applying the cartesian method does allow the smooth trend lines to be created
ggplot(mtcars, aes(x = wt, y = hp, color = fam)) +
  geom_point() +
  geom_smooth() +
  # Add Cartesian coordinates with x limits from 3 to 6
  coord_cartesian(xlim = c(3, 6))
