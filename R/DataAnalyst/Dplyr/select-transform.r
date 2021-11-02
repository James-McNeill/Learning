# Selecting and transforming data

# A. Select
# 1. Select columns
# Glimpse the counties table
glimpse(counties)

counties %>%
  # Select state, county, population, and industry-related columns (the : allows for a range of columns to be selected that exist between the first:end columns)
  select(state, county, population, professional:production) %>%
  # Arrange service in descending order 
  arrange(desc(service))

# 2. Select helpers
# ?select_helpers : code input to console provides overview 
# contains(): include the column names that contain the word being referenced
# starts_with(): include the prefix for the column name
# ends_with(): include the suffix for the column name
# last_col(): returns the last column from the table

counties %>%
  # Select the state, county, population, and those ending with "work"
  select(state, county, population, ends_with("work")) %>%
  # Filter for counties that have at least 50% of people engaged in public work
  filter(public_work >= 50)

# 3. Exclude column from selection. Code will exclude column from the selection and return all other columns
counties %>%
  select(-census_id)

# B. Rename verb
# 1. Rename a column after count()
counties %>%
  # Count the number of counties in each state
  count(state) %>%
  # Rename the n column to num_counties. The column n is created by default when using the count() verb
  rename(num_counties = n)

# 2. Rename methods
# a. Rename within the select method
counties %>%
  # Select state, county, and poverty as poverty_rate
  select(state, county, poverty_rate = poverty)
# b. Rename within the rename method
counties %>%
  # Select state, county, and poverty as poverty_rate
  select(state, county, poverty) %>%
  rename(poverty_rate = poverty)

# C. Transmute verb
# Combines the select() and mutate() verbs

# 1. Using transmute
counties %>%
  # Keep the state, county, and populations columns, and add a density column
  transmute(state, county, population, density = population / land_area) %>%
  # Filter for counties with a population greater than one million 
  filter(population > 1000000) %>%
  # Sort density in ascending order 
  arrange(density)

# D. All the verbs together. Choosing the most appropriate
# Change the name of the unemployment column
counties %>%
  rename(unemployment_rate = unemployment)

# Keep the state and county columns, and the columns containing poverty
counties %>%
  select(state, county, contains("poverty"))

# Calculate the fraction_women column without dropping the other columns
counties %>%
  mutate(fraction_women = women / population)

# Keep only the state, county, and employment_rate columns
counties %>%
  transmute(state, county, employment_rate = employed / population)
