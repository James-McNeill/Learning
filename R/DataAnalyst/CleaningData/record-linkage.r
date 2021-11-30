# Record linkage techniques
# Allows for the combining of datasets that have similar keys which are not completely exact

# A. Comparing strings
# 1. Small distance, small difference
# The stringdist package has been loaded for you.
# Each method performs a different combination of possible actions to compare differences in strings.
# Common actions include; insertion, deletion, subsitution and transposition
stringdist("las angelos", "los angeles", method = "dl")
stringdist("las angelos", "los angeles", method = "lcs")
stringdist("las angelos", "los angeles", method = "jaccard")

# 2. Fixing typos with string distance
# dplyr and fuzzyjoin are loaded, and zagat and cities are available
# Count the number of each city variation
zagat %>%
  count(city)

# Join zagat and cities and look at results
zagat %>%
  # Left join based on stringdist using city and city_actual cols
  stringdist_left_join(cities, by = c("city" = "city_actual")) %>%
  # Select the name, city, and city_actual cols
  select(c("name", "city", "city_actual"))

# B. Generating and comparing pairs
# 1. Pair blocking
# Load reclin
library(reclin)

# Generate all possible pairs
pair_blocking(zagat, fodors)

# Generate pairs with same city. Ensures that some form of filtering is applied, otherwise all possible combinations are created
pair_blocking(zagat, fodors, blocking_var = "city")

# 2. Comparing pairs
# Generate pairs
pair_blocking(zagat, fodors, blocking_var = "city") %>%
  # Compare pairs by name using lcs()
  compare_pairs(by = "name",
      default_comparator = lcs())

# Generate pairs
pair_blocking(zagat, fodors, blocking_var = "city") %>%
  # Compare pairs by name, phone, addr
  compare_pairs(by = c("name", "phone", "addr"),
      default_comparator = jaro_winkler())

# C. Scoring and linking
# 1. Scoring and linking put together
# Create pairs
pair_blocking(zagat, fodors, blocking_var = "city") %>%
  # Compare pairs
  compare_pairs(by = "name", default_comparator = jaro_winkler()) %>%
  # Score pairs. Performs a probalistic review of the paired scores. Assigns highest probability to most appropriate match
  score_problink() %>%
  # Select pairs. Creates binary column that relates to the pair which should be used to match
  select_n_to_m() %>%
  # Link data. Performs the match
  link()
