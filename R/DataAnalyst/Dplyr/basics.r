# Getting started with dplyr within R

# 1. Glimpse at a dataset: provides the details of what the overall dataset looks like
glimpse(counties)

# 2. Select the columns from a dataset using the pipe operator and the select() verb
counties %>%
  # Select the columns
  select(state, county, population, poverty)

# 3. Arranging rows
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, self_employed)

counties_selected %>%
  # Add a verb to sort in descending order of public_work
  arrange(desc(public_work))

# 4. Filtering for conditions
counties_selected <- counties %>%
  select(state, county, population)

counties_selected %>%
  # Filter for counties with a population above 1000000
  filter(state == 'California' & population > 1000000)

# 5. Filtering and arranging
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, self_employed)

# Filter for Texas and more than 10000 people; sort in descending order of private_work
counties_selected %>%
  # Filter for Texas and more than 10000 people
  filter(state == 'Texas' & population > 10000) %>%
  # Sort in descending order of private_work
  arrange(desc(private_work))

# 6. Mutate and arranging
counties_selected <- counties %>%
  select(state, county, population, public_work)

# Mutate is used to create a new column
counties_selected %>%
  mutate(public_workers = public_work * population / 100) %>%
  # Sort in descending order of the public_workers column
  arrange(desc(public_workers))

# 7. Mutate a new variable
counties_selected <- counties %>%
  # Select the columns state, county, population, men, and women
  select(state, county, population, men, women)

counties_selected %>%
  # Calculate proportion_women as the fraction of the population made up of women
  mutate(proportion_women = women / population)

# 8. All together, select, filter, mutate and arrange
counties %>%
  # Select the five columns 
  select(state, county, population, men, women) %>%
  # Add the proportion_men variable
  mutate(proportion_men = men / population) %>%
  # Filter for population of at least 10,000
  filter(population >= 10000) %>%
  # Arrange proportion of men in descending order 
  arrange(desc(proportion_men))
