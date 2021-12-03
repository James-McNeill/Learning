# Conversion from wide to long and back again

# A. From wide to long
# 1. Pivot_longer()
nuke_df %>% 
  # Pivot the data to a longer format
  pivot_longer(
    -year, 
    # Overwrite the names of the two new columns
    names_to = "country", 
    values_to = "n_bombs"
  ) %>% 
  # Replace NA values for n_bombs with 0L
  replace_na(list(n_bombs = 0L)) %>% 
  # Plot the number of bombs per country over time
  ggplot(aes(x = year, y = n_bombs, color = country)) +
  geom_line()
