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
