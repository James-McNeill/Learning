# Selection of matrix elements
# my_matrix[1,2]: selects the element at the first row and second column.
# my_matrix[1:3,2:4]: results in a matrix with the data on the rows 1, 2, 3 and columns 2, 3, 4.
# my_matrix[,1]: selects all elements of the first column.
# my_matrix[1,]: selects all elements of the first row.

# all_wars_matrix is available in your workspace
all_wars_matrix

# Select the non-US revenue for all movies
non_us_all <- all_wars_matrix[,2]
  
# Average non-US revenue
mean(non_us_all)
  
# Select the non-US revenue for first two movies
non_us_some <- all_wars_matrix[1:2, 2]
  
# Average non-US revenue for first two movies
mean(non_us_some)
