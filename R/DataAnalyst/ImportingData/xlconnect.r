# Reproducible Excel work with XLConnect

# A. Reading sheets
# 1. Connect to a workbook
# urbanpop.xlsx is available in your working directory

# Load the XLConnect package
library("XLConnect")

# Build connection to urbanpop.xlsx: my_book
my_book <- loadWorkbook("urbanpop.xlsx")

# Print out the class of my_book
class(my_book)

# 2. List and read Excel sheets
# XLConnect is already available

# Build connection to urbanpop.xlsx
my_book <- loadWorkbook("urbanpop.xlsx")

# List the sheets in my_book
getSheets(my_book)

# Import the second sheet in my_book
my_book_1 <- readWorksheet(my_book, sheet = 2)
my_book_1
