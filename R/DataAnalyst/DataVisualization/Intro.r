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
