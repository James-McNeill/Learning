# Interactions

# Explore the effect of interactions between explanatory variables. Considering interactions allows 
# for more realistic models that can have better predictive power. You'll also deal with Simpson's 
# Paradox: a non-intuitive result that arises when you have multiple explanatory variables.

# One model per category
# From previous step
taiwan_0_to_15 <- taiwan_real_estate %>%
  filter(house_age_years == "0 to 15")
taiwan_15_to_30 <- taiwan_real_estate %>%
  filter(house_age_years == "15 to 30")
taiwan_30_to_45 <- taiwan_real_estate %>%
  filter(house_age_years == "30 to 45")

# Model price vs. no. convenience stores using 0 to 15 data
mdl_0_to_15 <- lm(price_twd_msq ~ n_convenience, data = taiwan_0_to_15)

# Model price vs. no. convenience stores using 15 to 30 data
mdl_15_to_30 <- lm(price_twd_msq ~ n_convenience, data = taiwan_15_to_30)

# Model price vs. no. convenience stores using 30 to 45 data
mdl_30_to_45 <- lm(price_twd_msq ~ n_convenience, data = taiwan_30_to_45)

# See the results
mdl_0_to_15
mdl_15_to_30
mdl_30_to_45

# Predictions with multiple models
# From previous step
explanatory_data <- tibble(
  n_convenience = 0:10
)

# Add column of predictions using "0 to 15" model and explanatory data 
prediction_data_0_to_15 <- explanatory_data %>% 
  mutate(
    price_twd_msq = predict(mdl_0_to_15, explanatory_data)
  )

# Same again, with "15 to 30"
prediction_data_15_to_30 <- explanatory_data %>% 
  mutate(
    price_twd_msq = predict(mdl_15_to_30, explanatory_data)
  )

# Same again, with "30 to 45"
prediction_data_30_to_45 <- explanatory_data %>% 
  mutate(
    price_twd_msq = predict(mdl_30_to_45, explanatory_data)
  )

# Visualizing multiple models
# Extend the plot to include prediction points
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq, color = house_age_years)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add points using prediction_data_0_to_15, colored red, size 3, shape 15
  geom_point(data = prediction_data_0_to_15, color = "red", size = 3, shape = 15) +
  # Add points using prediction_data_15_to_30, colored green, size 3, shape 15
  geom_point(data = prediction_data_15_to_30, color = "green", size = 3, shape = 15) +
  # Add points using prediction_data_30_to_45, colored blue, size 3, shape 15
  geom_point(data = prediction_data_30_to_45, color = "blue", size = 3, shape = 15)

