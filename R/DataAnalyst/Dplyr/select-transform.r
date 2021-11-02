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
