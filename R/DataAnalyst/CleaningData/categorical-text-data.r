# Working to resolve issues with Categorical and Text data

# A. Checking membership
# 1. Checking if a row is a member between two DataFrames

# Count the number of occurrences of dest_size
sfo_survey %>%
  count(dest_size)

# Find bad dest_size rows
sfo_survey %>% 
  # Join with dest_sizes data frame to get bad dest_size rows
  anti_join(dest_sizes, sfo_survey, by = "dest_size") %>%
  # Select id, airline, destination, and dest_size cols
  select(id, airline, destination, dest_size)

# Remove bad dest_size rows
sfo_survey %>% 
  # Join with dest_sizes
  semi_join(dest_sizes, sfo_survey, by = "dest_size") %>%
  # Count the number of each dest_size
  count(dest_size)

# B. Categorical data problems
# 1. Identifying inconsistency
# Remove bad dest_size rows
sfo_survey %>% 
  # Join with dest_sizes
  semi_join(dest_sizes, sfo_survey, by = "dest_size") %>%
  # Count the number of each dest_size
  count(dest_size)
