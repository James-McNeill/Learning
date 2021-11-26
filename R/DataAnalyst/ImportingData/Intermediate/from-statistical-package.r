# Working with data that is taken from statistical packages
# Examples are shown for SAS, STATA and SPSS

# A. haven
# This is one of the packages that can be used to import data
# A very fast package for working with external data types
# 1. Import SAS data
# Load the haven package
library(haven)

# Import sales.sas7bdat: sales
sales <- read_sas("sales.sas7bdat")

# Display the structure of sales
str(sales)

