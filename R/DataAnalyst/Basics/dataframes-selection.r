# Performing selection tasks on the dataframe

# Print out diameter of Mercury (row 1, column 3)
planets_df[1,3]

# Print out data for Mars (entire fourth row)
planets_df[4,]

# Select first 5 values of diameter column - making use of the column name
planets_df[1:5, "diameter"]
