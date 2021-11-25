# Working with readr and data.table

# A. read_csv() and read_tsv()
# read_csv() is a wrapper function around read_delim() that handles all the default parameter arguments

# 1. read_csv()
# Load the readr package
library("readr")

# Import potatoes.csv with read_csv(): potatoes. read_csv() is a method from the readr package
potatoes <- read_csv("potatoes.csv")

# 2. read_tsv(). tsv() is short for tab separated values
# readr is already loaded

# Column names. Have to add these as the input file did not contain a header row
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import potatoes.txt: potatoes
potatoes <- read_tsv("potatoes.txt", col_names = properties)

# Call head() on potatoes
head(potatoes)

# B. read_delim()
# 1. read_delim()
# Just as read.table() was the main utils function, read_delim() is the main readr function.
# readr is already loaded

# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import potatoes.txt using read_delim(): potatoes
potatoes <- read_delim("potatoes.txt", col_names = properties, delim = "\t")

# Print out potatoes
potatoes

# 2. skip and n_max
# skip: number of rows to skip
# n_max: number of rows to keep
# readr is already loaded

# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import 5 observations from potatoes.txt: potatoes_fragment. Have to ensure the col_names are included so that the columns are assigned correctly
potatoes_fragment <- read_tsv("potatoes.txt", skip = 6, n_max = 5, col_names = properties)

# 3. col_types()
# readr is already loaded

# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import all data, but force all columns to be character: potatoes_char. Can include the col_types as: c = character, d = double, i = integer and l = logical.
# If a NULL value is provided or col_types is not included then readr will aim to figure out the column type by itself
potatoes_char <- read_tsv("potatoes.txt", col_types = "cccccccc", col_names = properties)

# Print out structure of potatoes_char
str(potatoes_char)

# 4. col_types() with collectors
# readr is already loaded

# Import without col_types
hotdogs <- read_tsv("hotdogs.txt", col_names = c("type", "calories", "sodium"))

# Display the summary of hotdogs
summary(hotdogs)

# The collectors you will need to import the data. collector values can be passed as a list to the col_types KW parameter
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

# Edit the col_types argument to import the data correctly: hotdogs_factor
hotdogs_factor <- read_tsv("hotdogs.txt",
                           col_names = c("type", "calories", "sodium"),
                           col_types = list(fac, int, int))

# Display the summary of hotdogs_factor
summary(hotdogs_factor)

# C. data.table
# 1. fread()
# Similar to read.table() but only much faster
# load the data.table package using library()
library(data.table)

# Import potatoes.csv with fread(): potatoes
potatoes <- fread("potatoes.csv")

# Print out potatoes
potatoes

# 2. fread: more advanced use
# select: allows the user to select columns
# drop: allows the user to drop columns
# fread is already loaded

# Import columns 6 and 8 of potatoes.csv: potatoes
potatoes <- fread("potatoes.csv", select = c("texture", "moistness"))

# Plot texture (x) and moistness (y) of potatoes
plot(potatoes$texture, potatoes$moistness)
