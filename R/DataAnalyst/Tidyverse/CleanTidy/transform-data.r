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

