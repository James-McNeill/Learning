# Introduction to Data Visualization using ggplot2

# A. Initial plots
# 1. First plot
# Load the ggplot2 package
library(ggplot2)

# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(cyl, mpg)) +
  geom_point()

# 2. Change data column types for plots. Ensuring that the correct data type is being used
# Converting the numeric column to a categorical column
# Load the ggplot2 package
library(ggplot2)

# Change the command below so that cyl is treated as factor. Using the factor() method helps to convert the data type
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_point()

# B. Grammar graphics
# Edit to add a color aesthetic mapped to disp
ggplot(mtcars, aes(wt, mpg, color = disp)) +
  geom_point()

# Change the color aesthetic to a size aesthetic
ggplot(mtcars, aes(wt, mpg, size = disp)) +
  geom_point()

# C. ggplot2 layers
# 1. Adding geometries
# geom_point(): adds points (as in a scatter plot)
# geom_smooth(): adds a smooth trend curve
ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  geom_smooth()

# 2. Changing one or multiple geom attributes
# alpha: KW param is used to control the opacity of the data points
# adding color to the geometry makes a trend line for each of the clarity categories
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point(alpha = 0.4) +
  geom_smooth()