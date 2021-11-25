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
