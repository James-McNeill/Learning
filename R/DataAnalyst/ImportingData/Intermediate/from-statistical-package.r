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

# 2. Import STATA data
# haven is already loaded

# Import the data from the URL: sugar
sugar <- read_dta("http://assets.datacamp.com/production/course_1478/datasets/trade.dta")

# Structure of sugar
str(sugar)

# Convert values in Date column to dates. When character variables are imported then convert the data type to the unique levels.
# This method helps to ensure that the variable is converted to the correct format
sugar$Date <- as.Date(as_factor(sugar$Date))

# Structure of sugar again
str(sugar)

# 3. Import SPSS data
# haven is already loaded

# Import person.sav: traits
traits <- read_sav("person.sav")

# Summarize traits
summary(traits)

# Print out a subset. Method allows us to pass filters to the second positional parameter (subset)
subset(traits, traits$Extroversion > 40 & traits$Agreeableness > 40)

# 4. Factorize, round two
# Import SPSS data from the URL: work
work <- read_sav("http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/employee.sav")

# Display summary of work$GENDER
summary(work$GENDER)

# Convert work$GENDER to a factor
work$GENDER <- as_factor(work$GENDER)

# Display summary of work$GENDER again
summary(work$GENDER)
