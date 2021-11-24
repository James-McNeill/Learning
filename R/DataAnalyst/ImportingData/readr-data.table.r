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
