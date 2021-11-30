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

# 2. Summarize the data
# Load skimr
library(skimr)

# Edit to filter, group by, and skim
bakeoff %>% 
  filter(!is.na(us_season)) %>% 
  group_by(us_season)  %>% 
  skim()

# C. Count with your data
# 1. Distinct and count
# View distinct results
bakeoff %>%
    distinct(result)

# Count rows for each result
bakeoff %>% 
  count(result)

# Count whether or not star baker
bakeoff %>% 
  count(result == "SB")

# 2. Count episodes
# Count the number of rows by series and episode
bakeoff %>%
    count(series, episode)

# Add second count by series
bakeoff %>% 
  count(series, episode) %>%
  count(series)

# 3. Count bakers
# Count the number of rows by series and baker
bakers_by_series <- bakeoff %>% 
  count(series, baker)
  
# Print to view
bakers_by_series
  
# Count again by series
bakers_by_series %>% 
  count(series)
  
# Count again by baker
bakers_by_series %>%
  count(baker, sort = TRUE)
