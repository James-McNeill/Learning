# Assessing model fit

# You’ll learn how to quantify how well a linear regression model fits, diagnose model problems using visualizations, 
# and understand the leverage and influence of each observation used to create the model.

# Coefficient of determination - R-squared
# Print a summary of mdl_click_vs_impression_orig
summary(mdl_click_vs_impression_orig)

# Print a summary of mdl_click_vs_impression_trans
summary(mdl_click_vs_impression_trans)

# Get coeff of determination for mdl_click_vs_impression_orig
mdl_click_vs_impression_orig %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out r.squared
  pull(r.squared)

# Do the same for the transformed model
mdl_click_vs_impression_trans %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out r.squared
  pull(r.squared)

# Residual standard error
# Residual standard error (RSE) is a measure of the typical size of the residuals. Equivalently, 
# it's a measure of how badly wrong you can expect predictions to be. Smaller numbers are better, with zero being a perfect fit to the data.
# Get RSE for mdl_click_vs_impression_orig
mdl_click_vs_impression_orig %>% 
  # Get the model-level details
  glance %>% 
  # Pull out sigma
  pull(sigma)

# Do the same for the transformed model
mdl_click_vs_impression_trans %>% 
  # Get the model-level details
  glance %>% 
  # Pull out sigma
  pull(sigma)

# Drawing diagnostic plots. library(ggfortify) was loaded. autoplot creates three plots using this method. documentation contains the description for each number
# Plot the three diagnostics for mdl_price_vs_conv
autoplot(
    mdl_price_vs_conv,
    which = 1:3,
    nrow = 3,
    ncol = 1
)

# Leverage and influence
# Leverage
# Leverage measures how unusual or extreme the explanatory variables are for each observation. 
# Very roughly, a high leverage means that the explanatory variable has values that are different to other points in the dataset.
# In the case of simple linear regression, where there is only one explanatory value, this typically means values with a very high or very low explanatory value.

# Influence
# Influence measures how much a model would change if each observation was left out of the model calculations, one at a time. 
# That is, it measures how different the prediction line would look if you ran a linear regression on all data points except that point, 
# compared to running a linear regression on the whole dataset.

# The standard metric for influence is Cook's distance, which calculates influence based on the size of the residual and the leverage of the point.

# Extracting leverage
mdl_price_vs_dist %>% 
  # Augment the model
  augment() %>% 
  # Arrange rows by descending leverage
  arrange(desc(.hat)) %>% 
  # Get the head of the dataset
  head()

# Extracting influence
mdl_price_vs_dist %>% 
  # Augment the model
  augment() %>% 
  # Arrange rows by descending Cook's distance
  arrange(desc(.cooksd)) %>% 
  # Get the head of the dataset
  head()

# Plot the three outlier diagnostics for mdl_price_vs_dist
autoplot(
    mdl_price_vs_dist,
    which = 4:6,
    nrow = 3,
    ncol = 1
)
