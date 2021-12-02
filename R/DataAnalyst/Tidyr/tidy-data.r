# What is tidy data

# A. Tidy data structure
# 1. Multiple variables per column
netflix_df %>% 
  # Split the duration column into value and unit columns. Using convert parameter creates the appropriate column data type conversion
  separate(duration, into = c("value", "unit"), sep = " ", convert = TRUE)

