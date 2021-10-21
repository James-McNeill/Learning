# Performing basic data wrangling tasks

# Load the gapminder package
library(gapminder)

# Load the dplyr package
library(dplyr)

# Look at the gapminder dataset
gapminder

# 1. Verb - filter
library(gapminder)
library(dplyr)

# Filter the gapminder dataset for the year 1957. %>%: represents a pipe
gapminder %>% filter(year == 1957)

# Filter for China in 2002
gapminder %>%
    filter(country == "China", year == 2002)
