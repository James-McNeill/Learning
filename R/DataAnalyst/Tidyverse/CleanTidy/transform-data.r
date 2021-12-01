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
