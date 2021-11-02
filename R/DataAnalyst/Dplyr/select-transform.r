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
