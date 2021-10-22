# Working with data summarizing and grouping

# 1. Summarize - basics
library(gapminder)
library(dplyr)

# Summarize to find the median life expectancy
gapminder %>%
    summarize(medianLifeExp = median(lifeExp))

# Filter for 1957 then summarize the median life expectancy
gapminder %>%
    filter(year == 1957) %>%
    summarize(medianLifeExp = median(lifeExp))

# Filter for 1957 then summarize the median life expectancy and the maximum GDP per capita
gapminder %>%
    filter(year == 1957) %>%
    summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# 2. Group by
# Find median life expectancy and maximum GDP per capita in each year
gapminder %>%
    group_by(year) %>%
    summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each continent in 1957
gapminder %>%
    filter(year == 1957) %>%
    group_by(continent) %>%
    summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each continent/year combination
gapminder %>%
    group_by(continent, year) %>%
    summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# 3. Visualize the summary tables
library(gapminder)
library(dplyr)
library(ggplot2)

by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Create a scatter plot showing the change in medianLifeExp over time. expand_limits: provides capability to set origin
ggplot(by_year, aes(x = year, y = medianLifeExp)) +
  geom_point() +
  expand_limits(y = 0)
