# Making predictions and model objects

# Predicting house prices
# Create a tibble with n_convenience column from zero to ten. Can be easier when aiming to extrapolate analysis
explanatory_data <- tibble(
  n_convenience = 0:10
)

# Edit this, so predictions are stored in prediction_data
prediction_data <- explanatory_data %>%
  mutate(
    price_twd_msq = predict(mdl_price_vs_conv, explanatory_data) # predict(model, data)
  )

# See the result
prediction_data

# Add to the plot
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a point layer of prediction data, colored yellow. Prediction points lie on the fitted regression line
  geom_point(data = prediction_data, color = "yellow")

# Working with model objects
# Get the model coefficients of mdl_price_vs_conv
coefficients(mdl_price_vs_conv)

# Get the fitted values of mdl_price_vs_conv
fitted(mdl_price_vs_conv)

# Get the residuals of mdl_price_vs_conv
residuals(mdl_price_vs_conv)

# Print a summary of mdl_price_vs_conv
summary(mdl_price_vs_conv)

# Manually predicting house prices
# Get the coefficients of mdl_price_vs_conv
coeffs <- coefficients(mdl_price_vs_conv)

# Get the intercept
intercept <- coeffs[1]

# Get the slope
slope <- coeffs[2]

explanatory_data %>% 
  mutate(
    # Manually calculate the predictions
    price_twd_msq = intercept + slope * n_convenience
  )

# Compare to the results from predict()
predict(mdl_price_vs_conv, explanatory_data)

# Using broom
# The broom package contains functions that decompose models into three data frames: 
# one for the coefficient-level elements (the coefficients themselves, as well as p-values for each coefficient), 
# the observation-level elements (like fitted values and residuals), and the model-level elements (mostly performance metrics).

# Get the coefficient-level elements of the model. Produces data frame of model values
tidy(mdl_price_vs_conv)

# Get the observation-level elements of the model. Produces model metrics for each observation
augment(mdl_price_vs_conv)

# Get the model-level elements of the model. Summary stats for the model
glance(mdl_price_vs_conv)
