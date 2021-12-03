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

# 2. Big tech stock prices
stock_df %>% 
  # Pivot the data to create 3 new columns: year, week, price
  pivot_longer(
    -company,
    names_to = c("year", "week"),
    values_to = "price",
    names_sep = "_week",
    names_transform = list(
      year = as.integer,
      week = as.integer)
  ) %>%
  # Create a line plot with price per week, color by company
  ggplot(aes(x = week, y = price, color = company)) +
  geom_line() +
  facet_grid(. ~ year)

# C. Deriving variables from complex column headers
# 1. Space dogs
space_dogs_df %>% 
  pivot_longer(
    # Add the columns to pivot
    c(name_1, name_2, gender_1, gender_2),
    names_sep = "_",
    # Complete the names_to argument to re-use the first part of the column headers
    names_to = c(".value",  "dog_id"),
    # Make sure NA values are dropped
    values_drop_na = TRUE
  )

# 2. WHO obesity Vs life expectancy
who_df %>% 
  # Put each variable in its own column
  pivot_longer(
    -country,
    names_to = c("year", "sex", ".value"),
    names_sep = "_", 
    names_transform = list("year" = as.integer)
  ) %>%
  # Create a plot with life expectancy over obesity
  ggplot(aes(x = pct.obese, y = life.exp, color = sex)) +
  geom_point()

# 3. Uncounting observations
dog_df %>% 
  # Create one row for each participant and add the id
  uncount(n_participants, .id = "dog_id")

# D. From long to wide
# 1. pivot_wider()
space_dogs_df %>% 
  # Pivot the data to a wider format
  pivot_wider(names_from = dog_id, values_from = gender, names_prefix = "gender_") %>% 
  # Drop rows with NA values
  drop_na() %>% 
  # Create a Boolean column on whether both dogs have the same gender
  mutate(same_gender = gender_1 == gender_2) %>% 
  summarize(pct_same_gender = mean(same_gender))
