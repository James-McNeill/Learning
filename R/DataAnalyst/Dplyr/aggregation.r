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

# 2. Summarize by state
counties_selected %>%
  group_by(state) %>%
  summarize(total_area = sum(land_area),
            total_population = sum(population)) %>%
  # Add a density column
  mutate(density = total_population / total_area) %>%
  # Sort by density in descending order
  arrange(desc(density))

# 3. Summarize by state and region
counties_selected %>%
  # Group and summarize to find the total population
  group_by(region, state) %>%
  summarize(total_pop = sum(population)) %>%
  # Calculate the average_pop and median_pop columns 
  summarize(average_pop = mean(total_pop),
            median_pop = median(total_pop)
  )
  
# C. top_n
# 1. Selecting a county from each region
counties_selected %>%
  # Group by region
  group_by(region) %>%
  # Find the greatest number of citizens who walk to work. Second positional parameter relates to the column to filter by
  top_n(1, walk)

# 2. Finding the highest average income
counties_selected %>%
  group_by(region, state) %>%
  # Calculate average income
  summarize(average_income = mean(income)) %>%
  # Find the highest income state in each region
  top_n(1, average_income)

# 3. Finding which state has the largest population by Metro / Nonmetro area. Then count how many states this takes place
counties_selected %>%
  # Find the total population for each combination of state and metro
  group_by(state, metro) %>%
  summarize(total_pop = sum(population)) %>%
  # Extract the most populated row for each state
  top_n(1, total_pop) %>%
  # Count the states with more people in Metro or Nonmetro areas
  ungroup(metro) %>%
  count(metro)
