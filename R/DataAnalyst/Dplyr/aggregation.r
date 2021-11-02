# Aggregating data

# A. Count() verb

# 1. Count and sorting
# Use count to find the number of counties in each region
# sort: sorts the data in descending order
counties_selected %>%
  count(region, sort = TRUE)
