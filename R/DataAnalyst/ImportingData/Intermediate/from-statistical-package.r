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

# B. foreign
# 1. Import STATA data
# Load the foreign package
library(foreign)

# Import florida.dta and name the resulting data frame florida
florida <- read.dta("florida.dta")

# Check tail() of florida
tail(florida)

# 2. Import STATA data (2)
# foreign is already loaded

# Specify the file path using file.path(): path
path <- file.path("worldbank/edequality.dta")

# Create and print structure of edu_equal_1
edu_equal_1 <- read.dta(path)
str(edu_equal_1)

# Create and print structure of edu_equal_2
edu_equal_2 <- read.dta(path, convert.factors = FALSE)
str(edu_equal_2)

# Create and print structure of edu_equal_3
edu_equal_3 <- read.dta(path, convert.underscore = TRUE)
str(edu_equal_3)

# Review the number of rows that match the subset filtering
nrow(subset(edu_equal_1, ethnicity_head == "Bulgaria" & income > 1000))

# 3. Import SPSS
# foreign is already loaded

# Import international.sav as a data frame: demo
demo <- read.spss("international.sav", to.data.frame = TRUE)

# Create boxplot of gdp variable of demo
boxplot(demo$gdp)

# 4. Import SPSS
# foreign is already loaded

# Import international.sav as demo_1
demo_1 <- read.spss("international.sav", to.data.frame = TRUE)

# Print out the head of demo_1
head(demo_1)

# Import international.sav as demo_2
demo_2 <- read.spss("international.sav", to.data.frame = TRUE, use.value.labels = FALSE)

# Print out the head of demo_2
head(demo_2)
