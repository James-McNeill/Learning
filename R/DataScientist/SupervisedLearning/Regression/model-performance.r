# Model performance

# Evaluating a model graphically

# From previous step
unemployment$predictions <- predict(unemployment_model)

# Calculate residuals
unemployment$residuals <-  unemployment$female_unemployment - unemployment$predictions

# Fill in the blanks to plot predictions (on x-axis) versus the residuals
ggplot(unemployment, aes(x = predictions, y = residuals)) + 
  geom_pointrange(aes(ymin = 0, ymax = residuals)) + 
  geom_hline(yintercept = 0, linetype = 3) + 
  ggtitle("residuals vs. linear model prediction")

# The gain curve evaluation
# For situations where order is more important than exact values, the gain curve helps you check if the model's predictions sort in the same order as the true outcome.
# unemployment (with predictions) is available
summary(unemployment)

# unemployment_model is available
summary(unemployment_model)

# Load the package WVPlots
library(WVPlots)

# Plot the Gain Curve
GainCurvePlot(unemployment, "predictions", "female_unemployment", "Unemployment model")

# Calculate RMSE
# You want RMSE to be small. How small is "small"? One heuristic is to compare the RMSE to the standard deviation of the outcome. 
# With a good model, the RMSE should be smaller.
# Print a summary of unemployment
summary(unemployment)

# For convenience put the residuals in the variable res
res <- unemployment$residuals

# Calculate RMSE, assign it to the variable rmse and print it
(rmse <- sqrt(mean(res ^ 2)))

# Calculate the standard deviation of female_unemployment and print it
(sd_unemployment <- sd(unemployment$female_unemployment))
