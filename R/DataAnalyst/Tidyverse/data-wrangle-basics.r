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

# Filter for China in 2002. Multiple filters can be separated by a comma
gapminder %>%
    filter(country == "China", year == 2002)

# 2. Verb - arrange, used for sorting data
# Sort in ascending order of lifeExp
gapminder %>%
    arrange(lifeExp)
  
# Sort in descending order of lifeExp
gapminder %>%
    arrange(desc(lifeExp))

# Filter for the year 1957, then arrange in descending order of population. Can use pipe operator multiple times (similar to bash) to produce the final dataset
gapminder %>%
    filter(year == 1957) %>%
        arrange(desc(pop))

# 3. Verb - mutate, used to alter or create a column
# Use mutate to change lifeExp to be in months
gapminder %>%
    mutate(lifeExp = lifeExp * 12)

# Use mutate to create a new column called lifeExpMonths
gapminder %>%
    mutate(lifeExpMonths = lifeExp * 12)

# 4. Bringing it all together
# Filter, mutate, and arrange the gapminder dataset
gapminder %>%
    filter(year == 2007) %>%
        mutate(lifeExpMonths = lifeExp * 12) %>%
            arrange(desc(lifeExpMonths))
