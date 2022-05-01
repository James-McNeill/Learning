# Simple linear regression

# View the data provided
# Invoke a spreadsheet-style data viewer on a matrix-like R object
View(taiwan_real_estate)

# Visualising two variables
# Add a linear trend line without a confidence ribbon
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE)
