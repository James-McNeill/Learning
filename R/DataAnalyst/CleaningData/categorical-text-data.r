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

# 2. Correcting inconsistencies
# dplyr and stringr are loaded and sfo_survey is available
# Add new columns to sfo_survey
sfo_survey <- sfo_survey %>%
  # dest_size_trimmed: dest_size without whitespace
  mutate(dest_size_trimmed = str_trim(dest_size),
         # cleanliness_lower: cleanliness converted to lowercase
         cleanliness_lower = str_to_lower(cleanliness))

# Count values of dest_size_trimmed
sfo_survey %>%
  count(dest_size_trimmed)

# Count values of cleanliness_lower
sfo_survey %>%
  count(cleanliness_lower)
