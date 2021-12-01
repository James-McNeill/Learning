# Transform data

# A. case_when()
# 1. Combine two variables
# Create skill variable with 3 levels
bakers_skill <- bakers %>% 
  mutate(skill = case_when(
    star_baker > technical_winner ~ "super_star",
    star_baker < technical_winner ~ "high_tech",
    TRUE ~ "well_rounded"
  ))
  
# Filter zeroes to examine skill variable
bakers_skill %>% 
  filter(star_baker == 0 & technical_winner == 0) %>% 
  count(skill)

# 2. Add another bin
# Add pipe to drop skill = NA
bakers_skill <- bakers %>% 
  mutate(skill = case_when(
    star_baker > technical_winner ~ "super_star",
    star_baker < technical_winner ~ "high_tech",
    star_baker == 0 & technical_winner == 0 ~ NA_character_,
    star_baker == technical_winner  ~ "well_rounded"
  )) %>% 
  drop_na(skill)
  
# Count bakers by skill
bakers_skill %>%
  count(skill)

# B. Factors
# library(forcats)
# 1. Cast a factor and examine levels
# Cast skill as a factor
bakers <- bakers %>% 
  mutate(skill = as.factor(skill))

# Examine levels
bakers %>%
  dplyr::pull(skill) %>%
  levels()

# 2. Plot factor counts
# Plot counts of bakers by skill, fill by winner
ggplot(bakers, aes(x = skill, fill = series_winner)) +
    geom_bar()

# Edit to reverse x-axis order
ggplot(bakers, aes(x = fct_rev(skill), fill = series_winner)) +
  geom_bar()

# C. Dates
# library(lubridate)
# 1. Cast characters as dates
# Add a line to extract labeled month
baker_dates_cast <- baker_dates %>% 
  mutate(last_date_appeared_us = dmy(last_date_appeared_us),
         last_month_us = month(last_date_appeared_us, label = TRUE))
         
# Make bar chart by last month
ggplot(baker_dates_cast, aes(x = last_month_us)) +
  geom_bar()

# 2. Calculate timespans
# Add a line to create whole months on air variable
baker_time <- baker_time  %>% 
  mutate(time_on_air = interval(first_date_appeared_uk, last_date_appeared_uk),
         weeks_on_air = time_on_air / weeks(1),
         months_on_air = time_on_air %/% months(1))

# D. Strings
# library(stringr)
# 1. Wrangle a character variable
# Add another mutate to replace "THIRD PLACE" with "RUNNER UP"and count
bakers <- bakers %>% 
  mutate(position_reached = str_to_upper(position_reached),
         position_reached = str_replace(position_reached, "-", " "),
         position_reached = str_replace(position_reached, "THIRD PLACE", "RUNNER UP"))

# Count rows
bakers %>%
  count(position_reached)

