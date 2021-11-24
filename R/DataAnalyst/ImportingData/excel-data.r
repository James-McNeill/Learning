# Importing excel data

# A. readxl() intro
# 1. List the sheet names of an excel file
# Load the readxl package
library("readxl")

# Print the names of all worksheets
excel_sheets("urbanpop.xlsx")

# 2. Import an excel sheet
# The readxl package is already loaded

# Read the sheets, one by one
pop_1 <- read_excel("urbanpop.xlsx", sheet = 1)
pop_2 <- read_excel("urbanpop.xlsx", sheet = 2)
pop_3 <- read_excel("urbanpop.xlsx", sheet = 3)

# Put pop_1, pop_2 and pop_3 in a list: pop_list
pop_list <- list(pop_1, pop_2, pop_3)

# Display the structure of pop_list
str(pop_list)
