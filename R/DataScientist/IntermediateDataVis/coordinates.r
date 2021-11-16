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

# B. Coordinates vs scales
# 1. Log transforming scales
# Add scale_*_*() functions
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  ggtitle("Scale_ functions")

# This option applies the transformation but maintains the original axes scale instead of converting the scale to a log10 which is what the plot above does
# Perform a log10 coordinate system transformation
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  coord_trans(x = "log10", y = "log10")

# 2. Adding stats to transformed scales
# Plot with a scale_*_*() function: performs the linear model regression fit with the scaled variable values
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a log10 x scale
  scale_x_log10() +
  # Add a log10 y scale
  scale_y_log10() +
  ggtitle("Scale functions")

# Plot with transformed coordinates. The smoothed line is trained after scaled changes but before coordinate transformations. So care is required
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a log10 coordinate transformation for x and y axes
  coord_trans(x = "log10", y = "log10")

# C. Double and flipped axes
# 1. Useful double axes
# From previous step
y_breaks <- c(59, 68, 77, 86, 95, 104)
y_labels <- (y_breaks - 32) * 5 / 9
secondary_y_axis <- sec_axis(
  trans = identity,
  name = "Celsius",
  breaks = y_breaks,
  labels = y_labels
)

# Update the plot. The plot now contains two y axis which help to show the two temperature measurements for the same chart
ggplot(airquality, aes(Date, Temp)) +
  geom_line() +
  # Add the secondary y-axis 
  scale_y_continuous(sec.axis = secondary_y_axis) +
  labs(x = "Date (1973)", y = "Fahrenheit")

# 2. Flipping axes
# Plot fcyl bars, filled by fam
ggplot(mtcars, aes(x = fcyl, fill = fam)) +
  # Place bars side by side
  geom_bar(position = "dodge")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar(position = "dodge") +
  # Flip the x and y coordinates
  coord_flip()

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Set a dodge width of 0.5 for partially overlapping bars
  geom_bar(position = position_dodge(0.5)) +
  coord_flip()

# 3. Flip axes to make elements easier to interpret
# Flip the axes to set car to the y axis. Provides the car names on the y axis to make things easier to read
ggplot(mtcars, aes(car, wt)) +
  geom_point() +
  labs(x = "car", y = "weight") +
  coord_flip()

# D. Polar coordinates
# 1. Pie charts
# Run the code, view the plot, then update it
ggplot(mtcars, aes(x = 1, fill = fcyl)) +
  geom_bar() +
  # Add a polar coordinate system
  coord_polar(theta = "y")

ggplot(mtcars, aes(x = 1, fill = fcyl)) +
  # Reduce the bar width to 0.1
  geom_bar(width = 0.1) +
  coord_polar(theta = "y") +
  # Add a continuous x scale from 0.5 to 1.5
  scale_x_continuous(limits = c(0.5, 1.5))

# 2. Wind rose plots. Reviewing hourly wind speed and direction data points from London during 2003
# Using wind, plot wd filled by ws
ggplot(wind, aes(x = wd, fill = ws)) +
  # Add a bar layer with width 1
  geom_bar(width = 1)

# Convert to polar coordinates:
ggplot(wind, aes(wd, fill = ws)) +
  geom_bar(width = 1) +
  coord_polar(start = -pi/16)
