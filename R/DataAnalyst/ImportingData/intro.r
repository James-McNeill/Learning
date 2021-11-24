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
# sep: separator is set to "/t" by default for tab delimited
# Import hotdogs.txt: hotdogs
hotdogs <- read.delim("hotdogs.txt", header = FALSE)

# Summarize hotdogs. Display summary stats
summary(hotdogs)

# 2. read.table()
# header: default to FALSE
# sep: default to ""
# Path to the hotdogs.txt file: path. Set this up as the file was stored within the data folder
path <- file.path("data", "hotdogs.txt")

# Import the hotdogs.txt file: hotdogs
hotdogs <- read.table(path, 
                      sep = "\t", 
                      col.names = c("type", "calories", "sodium"))

# Call head() on hotdogs
head(hotdogs)

# 3. arguments
# Finish the read.delim() call
hotdogs <- read.delim("hotdogs.txt", header = FALSE, col.names = c("type", "calories", "sodium"))

# Select the hot dog with the least calories: lily
lily <- hotdogs[which.min(hotdogs$calories), ]

# Select the observation with the most sodium: tom
tom <- hotdogs[which.max(hotdogs$sodium), ]

# Print lily and tom
lily
tom

# 4. Column classes
# Previous call to import hotdogs.txt
hotdogs <- read.delim("hotdogs.txt", header = FALSE, col.names = c("type", "calories", "sodium"))

# Display structure of hotdogs
str(hotdogs)

# Edit the colClasses argument to import the data correctly: hotdogs2. By using the argument "NULL" this means that the column will not be included
hotdogs2 <- read.delim("hotdogs.txt", header = FALSE, 
                       col.names = c("type", "calories", "sodium"),
                       colClasses = c("factor", "NULL", "numeric"))


# Display structure of hotdogs2
str(hotdogs2)
