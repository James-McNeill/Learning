# Use order function to sort the dataframe column

# Use order() to create positions - list of positions are assigned
positions <-  order(planets_df$diameter)

# Use positions to sort planets_df
planets_df[positions,]
