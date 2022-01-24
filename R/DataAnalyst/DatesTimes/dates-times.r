# Working with Dates and Times

# A. Introduction to dates
# 1. Specifying dates.
# The date R 3.0.0 was released. This date format is referenced as ISO 8601 and is the recommended format to use (YYYY-MM-DD)
x <- "2013-04-03"

# Examine structure of x
str(x)

# Use as.Date() to interpret x as a date
x_date <- as.Date(x)

# Examine structure of x_date
str(x_date)

# Store April 10 2014 as a Date
april_10_2014 <- as.Date("2014-04-10")

# 2. Automatic import
# Load the readr package
library(readr)

# Use read_csv() to import rversions.csv
releases <- read_csv("rversions.csv")

# Examine the structure of the date column
str(releases$Date)

# Load the anytime package. Package has sole objective to automatically parse strings as dates regardless of format
library(anytime)

# Various ways of writing Sep 10 2009
sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009")

# Use anytime() to parse sep_10_2009
anytime(sep_10_2009)

