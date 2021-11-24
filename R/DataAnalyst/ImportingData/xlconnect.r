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
