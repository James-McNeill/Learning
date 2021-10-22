# Working with data summarizing and grouping

# 1. Summarize - basics
library(gapminder)
library(dplyr)

# Summarize to find the median life expectancy
gapminder %>%
    summarize(medianLifeExp = median(lifeExp))
