# Parsing and Manipulating Dates and Times with lubridate

# A. Parsing dates with lubridate
# 1. Selecting the right parsing function
# As lubridate has a similar method name "date" which is also included in the base package, the lubridate will take precedence.
# If we need to use the "date" method from the base package then we need to select base::date to specify.
library(lubridate)

# Parse x 
x <- "2010 September 20th" # 2010-09-20
ymd(x)

# Parse y 
y <- "02.01.2010"  # 2010-01-02
dmy(y)

# Parse z 
z <- "Sep, 12th 2010 14:00"  # 2010-09-12T14:00
mdy_hm(z)

# 2. Specifying an order with 'parse_date_time()'
# Specify an order string to parse x
x <- "Monday June 1st 2010 at 4pm"
parse_date_time(x, orders = "AmdyIp")

# Specify order to include both "mdy" and "dmy"
two_orders <- c("October 7, 2001", "October 13, 2002", "April 13, 2003", 
  "17 April 2005", "23 April 2017")
parse_date_time(two_orders, orders = c("mdy", "dmy"))

# Specify order to include "dOmY", "OmY" and "Y"
short_dates <- c("11 December 1282", "May 1372", "1253")
parse_date_time(short_dates, orders = c("dOmY", "OmY", "Y"))

# B. Weather in Auckland
# 1. Import daily weather data
library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import CSV with read_csv()
akl_daily_raw <- read_csv("akl_weather_daily.csv")

# Print akl_daily_raw
print(akl_daily_raw)

# Parse date 
akl_daily <- akl_daily_raw %>%
  mutate(date = as.Date(date))

# Print akl_daily
print(akl_daily)

# Plot to check work
ggplot(akl_daily, aes(x = date, y = max_temp)) +
  geom_line() 

# 2. Import hourly weather data
library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import "akl_weather_hourly_2016.csv"
akl_hourly_raw <- read_csv("akl_weather_hourly_2016.csv")

# Print akl_hourly_raw
print(akl_hourly_raw)

# Use make_date() to combine year, month and mday 
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))

# Parse datetime_string 
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = parse_datetime(datetime_string)
  )

# Print date, time and datetime columns of akl_hourly
akl_hourly %>% select(date, time, datetime)

# Plot to check work
ggplot(akl_hourly, aes(x = datetime, y = temperature)) +
  geom_line()
