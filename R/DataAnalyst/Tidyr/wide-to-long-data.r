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

# 2. Obesity per country
obesity_df %>% 
  # Pivot the male and female columns
  pivot_longer(c(male, female),
               names_to = "sex",
               values_to = "pct_obese") %>% 
  # Create a scatter plot with pct_obese per country colored by sex
  ggplot(aes(x = pct_obese, color = sex,
             y = forcats::fct_reorder(country, both_sexes))) +
  geom_point() +
  scale_y_discrete(breaks = c("India", "Nauru", "Cuba", "Brazil",
                              "Pakistan", "Gabon", "Italy", "Oman",
                              "China", "United States of America")) +
  labs(x = "% Obese", y = "Country")

# 3. Bond movies by actor
bond_df %>% 
  # Pivot the data to long format
  pivot_longer(
    -Bond, 
    # Overwrite the names of the two newly created columns
    names_to = "decade", 
    values_to = "n_movies", 
    # Drop na values
    values_drop_na = TRUE, 
    # Transform the decade column data type to integer
    names_transform = list(decade = as.integer)
  ) %>% 
  ggplot(aes(x = decade + 5, y = n_movies, fill = Bond))+
  geom_col()

# B. Deriving variables from column headers
# 1. Bird of the year
bird_df %>%
  # Pivot the data to create a 2 column data frame
  pivot_longer(
    starts_with("points_"),
    names_to = "points",
    names_prefix = "points_",
    names_transform = list(points = as.integer),
    values_to = "species",
    values_drop_na = TRUE
  ) %>%
  group_by(species) %>% 
  summarize(total_points = sum(points)) %>% 
  slice_max(total_points, n = 5)
