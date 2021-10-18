# Performing selection tasks on the dataframe

# Print out diameter of Mercury (row 1, column 3)
planets_df[1,3]

# Print out data for Mars (entire fourth row)
planets_df[4,]

# Select first 5 values of diameter column - making use of the column name
planets_df[1:5, "diameter"]

# Select the rings variable from planets_df - the $variable_name allows us to subset the dataframe for all values in this column
rings_vector <- planets_df$rings
  
# Print out rings_vector
rings_vector
