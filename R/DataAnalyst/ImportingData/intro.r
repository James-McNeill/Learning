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

# B. read.delim() and read.table()
# 1. read.delim()
# header: by default set to TRUE, to show that the variable names are in the first row. Adjust if not the case
# Import hotdogs.txt: hotdogs
hotdogs <- read.delim("hotdogs.txt", header = FALSE)

# Summarize hotdogs. Display summary stats
summary(hotdogs)
