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

# 2. Aspect ratio 1: 1:1 ratios
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_jitter() +
  geom_smooth(method = "lm", se = FALSE) +
  # Fix the coordinate ratio
  coord_fixed(ratio = 1)

# 3. Aspect ratio 2: setting ratios. Adjusting the ratio to increase the width of the plot is common for time series plots in order to understand the data movements better
# Change the aspect ratio to 20:1
sun_plot +
  coord_fixed(ratio = 20)

# 4. Expand and clip
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(size = 2) +
  # Add Cartesian coordinates with zero expansion. This setting will clip data points from the plot
  coord_cartesian(expand = 0) +
  theme_classic()

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(size = 2) +
  # Turn clipping off
  coord_cartesian(expand = 0, clip = "off") +
  theme_classic() +
  # Remove axis lines
  theme(axis.line = element_blank())
