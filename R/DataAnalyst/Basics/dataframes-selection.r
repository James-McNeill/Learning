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

# Adapt the code to select all columns for planets with rings - select true values
planets_df[rings_vector, ]

# Select planets with diameter < 1
subset(planets_df, subset = diameter < 1)

# subset(my_df, subset = some_condition)
# my_df: dataframe to be reviewed
# subset: condition to filter dataframe on. Can use columns that are logical or create a filter string as shown above
