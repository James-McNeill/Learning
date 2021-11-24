# Working with readr and data.table

# A. read_csv() and read_tsv()
# read_csv() is a wrapper function around read_delim() that handles all the default parameter arguments

# 1. read_csv()
# Load the readr package
library("readr")

# Import potatoes.csv with read_csv(): potatoes. read_csv() is a method from the readr package
potatoes <- read_csv("potatoes.csv")
