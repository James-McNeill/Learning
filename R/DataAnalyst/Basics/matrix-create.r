# A matrix is a collection of elements of the same data type (numeric, character, or logical) 
# arranged into a fixed number of rows and columns. Since you are only working with rows and columns, 
# a matrix is called two-dimensional.

# Construct a matrix with 3 rows that contain the numbers 1 up to 9
matrix(1:9, byrow=TRUE, nrow=3)

# byrow: indicates that the matrix is filled by row. For columns use param of FALSE
# nrow: indicates the number of rows to fill

# Box office Star Wars (in millions!)
new_hope <- c(460.998, 314.4)
empire_strikes <- c(290.475, 247.900)
return_jedi <- c(309.306, 165.8)

# Create box_office
box_office <- c(new_hope, empire_strikes, return_jedi)

# Construct star_wars_matrix
star_wars_matrix <- matrix(box_office, byrow=TRUE, nrow=3)
