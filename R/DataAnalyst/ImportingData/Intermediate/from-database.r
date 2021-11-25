# Importing data from database

# A. Connect to database
# 1. Establish a connection
# Load the DBI package
library("DBI")

# Edit dbConnect() call
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "tweater", 
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
                 port = 3306,
                 user = "student",
                 password = "datacamp")

# B. Import data
# 1. List the database tables
# Build a vector of table names: tables
tables <- dbListTables(con)

# Display structure of tables
str(tables)

# 2. Import table
# Import the users table from tweater: users
users <- dbReadTable(con, "users")

# Print users
users
