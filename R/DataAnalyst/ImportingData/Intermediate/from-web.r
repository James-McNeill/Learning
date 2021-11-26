# Importing data from the web

# A. HTTP
# 1. Import flat files from the web
# Load the readr package
library("readr")

# Import the csv file: pools
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/swimming_pools.csv"
pools <- read_csv(url_csv)

# Import the txt file: potatoes
url_delim <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/potatoes.txt"
potatoes <- read_tsv(url_delim)

# Print pools and potatoes
pools
potatoes

# 2. Secure importing
# https URL to the swimming_pools csv file.
url_csv <- "https://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/swimming_pools.csv"

# Import the file using read.csv(): pools1
pools1 <- read.csv(url_csv)

# Load the readr package
library("readr")

# Import the file using read_csv(): pools2
pools2 <- read_csv(url_csv)

# Print the structure of pools1 and pools2
str(pools1)
str(pools2)

# B. Downloading files
# 1. Import Excel files from the web
# Load the readxl and gdata package
library("readxl")
library("gdata")

# Specification of url: url_xls
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/latitude.xls"

# Import the .xls file with gdata: excel_gdata
excel_gdata <- read.xls(url_xls)

# Download file behind URL, name it local_latitude.xls
download.file(url_xls, "local_latitude.xls")

# Import the local .xls file with readxl: excel_readxl. In order to get read_excel working, the work around is to use the download module from the utils package.
# Then we are able to import the downloaded file
excel_readxl <- read_excel("local_latitude.xls")

# 2. Downloading any file, secure or not
# https URL to the wine RData file. RData is an efficient way to store R Data
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/wine.RData"

# Download the wine file to your working directory
download.file(url_rdata, "wine_local.RData")

# Load the wine data into your workspace using load()
load("wine_local.RData")

# Print out the summary of the wine data
summary(wine)

# 3. httr (1)
# Load the httr package. Package allows for the GET, FETCH options
library("httr")

# Get the url, save response to resp
url <- "http://www.example.com/"
resp <- GET(url)

# Print resp
resp

# Get the raw content of resp: raw_content
raw_content <- content(resp, as = "raw")

# Print the head of raw_content
head(raw_content)

# 4. httr (2)
# httr is already loaded

# Get the url
url <- "http://www.omdbapi.com/?apikey=72bc447a&t=Annie+Hall&y=&plot=short&r=json"
resp <- GET(url)

# Print resp
resp

# Print content of resp as text
content(resp, as = "text")

# Print content of resp. By not specifying a format to convert to, R will work this out for itself. With the data being in JSON the method converted
# the resp content to an R list, which made it easier to use
content(resp)

# C. APIs & JSON
# 1. From JSON to R
# Load the jsonlite package
library("jsonlite")

# wine_json is a JSON
wine_json <- '{"name":"Chateau Migraine", "year":1997, "alcohol_pct":12.4, "color":"red", "awarded":false}'

# Convert wine_json into a list: wine
wine <- fromJSON(wine_json)

# Print structure of wine
str(wine)

# 2. Quandl API. Review of financial and economic data
# jsonlite is preloaded

# Definition of quandl_url
quandl_url <- "https://www.quandl.com/api/v3/datasets/WIKI/FB/data.json?auth_token=i83asDsiWUUyfoypkgMz"

# Import Quandl data: quandl_data
quandl_data <- fromJSON(quandl_url)

# Print structure of quandl_data
str(quandl_data)

# 3. OMDb API. Review of Movie data
# The package jsonlite is already loaded

# Definition of the URLs
url_sw4 <- "http://www.omdbapi.com/?apikey=72bc447a&i=tt0076759&r=json"
url_sw3 <- "http://www.omdbapi.com/?apikey=72bc447a&i=tt0121766&r=json"

# Import two URLs with fromJSON(): sw4 and sw3
sw4 <- fromJSON(url_sw4)
sw3 <- fromJSON(url_sw3)

# Print out the Title element of both lists
sw4$Title
sw3$Title

# Is the release year of sw4 later than sw3?
sw4$Year > sw3$Year

# D. JSON and jsonlite
# 1. JSON practice
# jsonlite is already loaded

# Challenge 1
json1 <- '[1, 2, 3, 4, 5, 6]'
fromJSON(json1)

# Challenge 2
json2 <- '{"a": [1, 2, 3], "b": [4, 5, 6]}'
fromJSON(json2)

# 2. JSON practice (2)
# jsonlite is already loaded

# Challenge 1
json1 <- '[[1, 2], [3, 4]]'
fromJSON(json1)

# Challenge 2
json2 <- '[{"a": 1, "b": 2}, {"a": 3, "b": 4}, {"a": 5, "b": 6}]'
fromJSON(json2)

# 3. toJSON()
# jsonlite is already loaded

# URL pointing to the .csv file
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/water.csv"

# Import the .csv file located at url_csv
water <- read.csv(url_csv, stringsAsFactors = FALSE)

# Convert the data file according to the requirements
water_json <- toJSON(water)

# Print out water_json
water_json

# 4. Minify and prettify
# minify(): shows the JSON format in a minified version
# prettify(): shows the JSON format in a spaced out version which is easier to visualize
# jsonlite is already loaded

# Convert mtcars to a pretty JSON: pretty_json
pretty_json <- toJSON(mtcars, pretty = TRUE)

# Print pretty_json
pretty_json

# Minify pretty_json: mini_json
mini_json <- minify(pretty_json)

# Print mini_json
mini_json
