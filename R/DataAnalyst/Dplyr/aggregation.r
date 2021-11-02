# Aggregating data

# A. Count() verb

# 1. Count and sorting
# Use count to find the number of counties in each region
# sort: sorts the data in descending order
counties_selected %>%
  count(region, sort = TRUE)

# 2. Count and weighting parameter
# Find number of counties per state, weighted by citizens, sorted in descending order
counties_selected %>%
  count(state, wt = citizens, sort = TRUE)

# 3. Count and mutate
counties_selected %>%
  # Add population_walk containing the total number of people who walk to work 
  mutate(population_walk = walk * population / 100) %>%
  # Count weighted by the new column, sort in descending order
  count(state, wt = population_walk, sort = TRUE)

# B. Summarizing
# 1. Summarize overview
counties_selected %>%
  # Summarize to find minimum population, maximum unemployment, and average income
  summarize(min_population = min(population),
            max_unemployment = max(unemployment),
            average_income = mean(income)
  )
