# Multiple linear regression

# See how modeling, and linear regression in particular, makes it easy to work with more than two explanatory variables.

# 3D visualizations
# With taiwan_real_estate, draw a 3D scatter plot of no. of conv. stores, sqrt dist to MRT, and price
taiwan_real_estate %$% # saves having to have the dataset in the scatter3D method three times
    scatter3D(n_convenience, sqrt(dist_to_mrt_m), price_twd_msq)

# Using taiwan_real_estate, plot sqrt dist to MRT vs. no. of conv stores, colored by price
ggplot(taiwan_real_estate, aes(n_convenience, sqrt(dist_to_mrt_m), color = price_twd_msq)) + 
  # Make it a scatter plot
  geom_point() +
  # Use the continuous viridis plasma color scale
  scale_color_viridis_c(option = "plasma")

# Modelling with two numeric explanatory variables
# From previous steps
mdl_price_vs_conv_dist <- lm(price_twd_msq ~ n_convenience + sqrt(dist_to_mrt_m), data = taiwan_real_estate)
explanatory_data <- expand_grid(n_convenience = 0:10, dist_to_mrt_m = seq(0, 80, 10) ^ 2)
prediction_data <- explanatory_data %>% 
  mutate(price_twd_msq = predict(mdl_price_vs_conv_dist, explanatory_data))

# Add predictions to plot
ggplot(
  taiwan_real_estate, 
  aes(n_convenience, sqrt(dist_to_mrt_m), color = price_twd_msq)
) + 
  geom_point() +
  scale_color_viridis_c(option = "plasma")+
  # Add prediction points colored yellow, size 3
  geom_point(data = prediction_data, color = "yellow", size = 3)
