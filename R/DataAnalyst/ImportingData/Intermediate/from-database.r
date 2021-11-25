# Importing data from database

# A. Connect to database
# 1. Establish a connection
# Load the DBI package
library("DBI")

# Edit dbConnect() call. Note that when all actions have been completed the connection should be disabled
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

# 3. Import all tables
# Get table names
table_names <- dbListTables(con)

# Import all tables using the lapply function
tables <- lapply(table_names, dbReadTable, conn = con)

# Print out tables
tables
