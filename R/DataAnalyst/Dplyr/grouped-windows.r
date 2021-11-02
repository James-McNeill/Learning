# Grouped mutates and window functions

# A. Grouped mutates
# 1. Finding the year each name is most common
# Calculate the fraction of people born each year with the same name
babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number / year_total) %>%
  # Find the year each name is most common
  group_by(name) %>%
  top_n(1, fraction)

# 2. Add total and maximum for each name
babynames %>%
  # Add columns name_total and name_max for each name
  group_by(name) %>%
  mutate(name_total = sum(number),
         name_max = max(number)) %>%
  # Ungroup the table 
  ungroup() %>%
  # Add the fraction_max column containing the number by the name maximum 
  mutate(fraction_max = number / name_max)

# 3. Visualizing the normalized change. Taking the data from the previous step and storing in variable (names_normalized)
names_filtered <- names_normalized %>%
  # Filter for the names Steven, Thomas, and Matthew
  filter(name %in% c('Steven', 'Thomas', 'Matthew'))

# Visualize these names over time
ggplot(names_filtered, aes(x = year, y = fraction_max, color = name)) +
geom_line()
