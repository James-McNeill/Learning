# Performing data visualization
# ggplot2: library that is used for data visualization's

# Load the ggplot2 package as well
library(gapminder)
library(dplyr)
library(ggplot2)

# Create gapminder_1952
gapminder_1952 <- gapminder %>% filter(year == 1952)
