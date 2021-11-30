# Using Tidyverse to explore data

# A. Import
# 1. Read csv file
# Load readr
library(readr)

# Create bakeoff but skip first row
bakeoff <- read_csv("bakeoff.csv", skip = 1)

# Print bakeoff
bakeoff

# 2. Assign missing values
# Load dplyr
library(dplyr)

# Filter rows where showstopper is UNKNOWN 
bakeoff %>% 
    filter(showstopper == "UNKNOWN")

# Edit to add list of missing values
bakeoff <- read_csv("bakeoff.csv", skip = 1,
                    na = c("", "NA", "UNKNOWN"))

# Filter rows where showstopper is NA 
bakeoff %>%
    filter(is.na(showstopper))

# B. Know your data
# 1. Arrange and glimpse. 
bakeoff %>% 
    arrange(us_airdate) %>% 
    glimpse()
