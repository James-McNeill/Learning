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

# Specifying interactions
# Aim is to have one model that benefits from the improvements seen with each individual model. This is where the interactions come into play. 
# Defining this single model is achieved through adding interactions between explanatory variables. R's formula syntax is flexible, and gives 
# you a couple of options, depending on whether you prefer concise code that is quick to type and to read, or explicit code that describes what 
# you are doing in detail.

# Model price vs both with an interaction using "times" syntax
lm(price_twd_msq ~ n_convenience * house_age_years, data = taiwan_real_estate)

# Model price vs both with an interaction using "colon" syntax. Both methods produce the same model outputs. All depends on syntax that is preferred
lm(price_twd_msq ~ n_convenience + house_age_years + n_convenience:house_age_years, data = taiwan_real_estate)

# Reviewing interactions
# Model price vs. house age plus an interaction, no intercept
mdl_readable_inter <- 
    lm(
        price_twd_msq ~ house_age_years + n_convenience:house_age_years + 0,
        data = taiwan_real_estate
    )

# See the result
mdl_readable_inter

# Get coefficients for mdl_0_to_15
coefficients(mdl_0_to_15)

# Get coefficients for mdl_15_to_30
coefficients(mdl_15_to_30)

# Get coefficients for mdl_30_to_45
coefficients(mdl_30_to_45)

# Look at the coefficients. Shows how one model can produce the same coefficients as the three separate models
coefficients(mdl_readable_inter)

# Predicting with interactions
# Make a grid of explanatory data
explanatory_data <- expand_grid(
  # Set n_convenience to zero to ten
  n_convenience = 0:10,
  # Set house_age_years to the unique values of that variable
  house_age_years = unique(taiwan_real_estate$house_age_years)
)

# See the result
explanatory_data

# Add predictions to the data frame
prediction_data <- explanatory_data %>%
  mutate(
    price_twd_msq = predict(mdl_price_vs_both_inter, explanatory_data)
  )

# Using taiwan_real_estate, plot price vs. no. of convenience stores, colored by house age
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq, color = house_age_years)) +
  # Make it a scatter plot
  geom_point() +
  # Add linear regression trend lines, no ribbon
  geom_smooth(method = "lm", se = FALSE) +
  # Add points from prediction_data, size 5, shape 15
  geom_point(data = prediction_data, size = 5, shape = 15)

# Manual predictions
# From previous step
coeffs <- coefficients(mdl_price_vs_both_inter)
intercept_0_15 <- coeffs[1]
intercept_15_30 <- coeffs[2]
intercept_30_45 <- coeffs[3]
slope_0_15 <- coeffs[4]
slope_15_30 <- coeffs[5]
slope_30_45 <- coeffs[6]

prediction_data <- explanatory_data %>% 
  mutate(
    # Consider the 3 cases to choose the price
    price_twd_msq = case_when(
      house_age_years == "0 to 15" ~ intercept_0_15 + slope_0_15 * n_convenience,
      house_age_years == "15 to 30" ~ intercept_15_30 + slope_15_30 * n_convenience,
      house_age_years == "30 to 45" ~ intercept_30_45 + slope_30_45 * n_convenience
    )   
  )

# See the result
prediction_data


# Simpsons paradox
# Sometimes modeling a whole dataset suggests trends that disagree with models on separate parts of that dataset. 
# This is known as Simpson's paradox. In the most extreme case, you may see a positive slope on the whole dataset, 
# and negative slopes on every subset of that dataset (or the other way around).

# Take a glimpse at the dataset
glimpse(auctions)

# Model price vs. opening bid using auctions
mdl_price_vs_openbid <- lm(price ~ openbid, data = auctions)

# See the result
mdl_price_vs_openbid

# Using auctions, plot price vs. opening bid as a scatter plot with linear regression trend lines. Openbid appears to have no impact on final price
ggplot(auctions, aes(openbid, price)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE)

