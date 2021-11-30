# Using Tidyverse to explore data

# A. Import
# 1. Read csv file
# Load readr
library(readr)

# Create bakeoff but skip first row
bakeoff <- read_csv("bakeoff.csv", skip = 1)

# Print bakeoff
bakeoff
