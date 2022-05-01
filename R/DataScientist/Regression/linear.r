# Simple linear regression

# View the data provided
# Invoke a spreadsheet-style data viewer on a matrix-like R object
View(taiwan_real_estate)

# Visualising two variables
# Add a linear trend line without a confidence ribbon
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE)

# Run a linear regression of price_twd_msq vs. n_convenience
lm(price_twd_msq ~ n_convenience, data = taiwan_real_estate)

# Using taiwan_real_estate, plot price_twd_msq
ggplot(taiwan_real_estate, aes(price_twd_msq)) +
  # Make it a histogram with 10 bins
  geom_histogram(bins = 10) +
  # Facet the plot so each house age group gets its own panel
  facet_wrap(vars(house_age_years))

# Calculating means by category
summary_stats <- taiwan_real_estate %>% 
  # Group by house age
  group_by(house_age_years) %>% 
  # Summarize to calculate the mean house price/area
  summarize(mean_by_group = mean(price_twd_msq))

# See the result
summary_stats

# Run a linear regression of price_twd_msq vs. house_age_years
mdl_price_vs_age <- lm(price_twd_msq ~ house_age_years, data = taiwan_real_estate)

# See the result. As there is only one categorical variable, the intercept will take a value for one of the segments of the variable. Then each coefficient
# will provide a value relating to this segment that is missing to arrive at the average price for the segment being reviewed
mdl_price_vs_age

# Update the model formula to remove the intercept. Adding an independent variable value of 0 means that the intercept is switched off. Then the coefficients
# will be relative to zero. This means that with this simple model each coefficient will then be the mean for that segment of the categorical variable
mdl_price_vs_age_no_intercept <- lm(
  price_twd_msq ~ house_age_years + 0, 
  data = taiwan_real_estate
)

# See the result
mdl_price_vs_age_no_intercept
