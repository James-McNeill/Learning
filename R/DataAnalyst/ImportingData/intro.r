# Introduction to working with data

# A. Intro and read.csv
# read.csv() is part of the utils package loaded at the beginning of each R session
# dir(): applied in the console, shows all of the files within the directory

# 1. read.csv()
# Import swimming_pools.csv: pools
pools <- read.csv("swimming_pools.csv")

# Print the structure of pools
str(pools)

# 2. stringsAsFactors
# Applying this parameter as false ensures that strings are treated as characters within the DataFrame
# Import swimming_pools.csv correctly: pools
pools <- read.csv("swimming_pools.csv", stringsAsFactors = FALSE)

# Check the structure of pools
str(pools)
