# Getting started with dplyr within R

# 1. Glimpse at a dataset: provides the details of what the overall dataset looks like
glimpse(counties)

# 2. Select the columns from a dataset using the pipe operator and the select() verb
counties %>%
  # Select the columns
  select(state, county, population, poverty)
