# Data quality check code
library(janitor)
library(dplyr)
library(tidyr)
library(skimr)

# Function to perform key data quality checks
data_quality_checks <- function(df) {
  # Remove duplicate rows
  df_cleaned <- df %>% distinct()
  
  # Check for missing values
  missing_values <- df_cleaned %>% summarise_all(~sum(is.na(.)))
  
  # Check for zero variance
  zero_variance <- df_cleaned %>% select_if(~sd(.) == 0) %>% colnames()
  
  # Check for constant columns
  constant_columns <- df_cleaned %>% summarise_all(~length(unique(.))) %>% filter_all(all_vars(. == 1)) %>% colnames()
  
  # Check for extreme values - not currently working
  #extreme_values <- df_cleaned %>% skimr::skim() %>% filter(p1 < min & p99 > max) %>% select(variable)
  
  # Combine the results into a data frame
  results <- data.frame(
    missing_values = t(missing_values),
    zero_variance = zero_variance,
    constant_columns = constant_columns
    #extreme_values = extreme_values$variable
  )
  
  # Return the results
  return(results)
}

# Example data frame
mydata <- data.frame(
  var1 = c(1, 2, 3, 4, NA),
  var2 = c(1, 1, 1, 1, 1),
  var3 = c(1, 2, 3, 4, 5),
  var4 = c(1, 2, 3, 4, 5)
)

# Perform data quality checks
output <- data_quality_checks(mydata)
