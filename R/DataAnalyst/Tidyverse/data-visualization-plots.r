# Working with data visualization plots

# 1. Line Plots
library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize the median gdpPercap by year, then save it as by_year
by_year <- gapminder %>%
                group_by(year) %>%
                summarize(medianGdpPercap = median(gdpPercap))

# Create a line plot showing the change in medianGdpPercap over time
ggplot(by_year, aes(x = year, y = medianGdpPercap)) +
    geom_line() +
    expand_limits(y = 0)

# Summarize the median gdpPercap by year & continent, save as by_year_continent
by_year_continent <- gapminder %>%
                        group_by(year, continent) %>%
                        summarize(medianGdpPercap = median(gdpPercap))

# Create a line plot showing the change in medianGdpPercap by continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
    geom_line() + 
    expand_limits(y = 0)

# 2. Bar plots
# Summarize the median gdpPercap by continent in 1952
by_continent <- gapminder %>%   
                    filter(year == 1952) %>%
                    group_by(continent) %>%
                    summarize(medianGdpPercap = median(gdpPercap))

# Create a bar plot showing medianGdp by continent
ggplot(by_continent, aes(x = continent, y = medianGdpPercap)) +
    geom_col()

# Filter for observations in the Oceania continent in 1952
oceania_1952 <- gapminder %>%
                    filter(continent == "Oceania", year == 1952)

# Create a bar plot of gdpPercap by country
ggplot(oceania_1952, aes(x = country, y = gdpPercap)) +
    geom_col()
