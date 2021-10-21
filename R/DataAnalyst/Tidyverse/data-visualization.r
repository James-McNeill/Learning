# Performing data visualization
# ggplot2: library that is used for data visualization's

# Load the ggplot2 package as well
library(gapminder)
library(dplyr)
library(ggplot2)

# Create gapminder_1952
gapminder_1952 <- gapminder %>% filter(year == 1952)

# 1. Produce scattergraph
# aes: relates to the axis
# geom_point(): added to signify that a geometric point layer is requested for the plot
# Change to put pop on the x-axis and gdpPercap on the y-axis
ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) +
  geom_point()

# 2. Add log scale to the axis
# scale_x_log10(): method converts the x axis variable to log base 10 scale. For y axis conversion just switch x with y
# Change this plot to put the x-axis on a log scale
ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) +
  geom_point() +
  scale_x_log10()
