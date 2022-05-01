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
