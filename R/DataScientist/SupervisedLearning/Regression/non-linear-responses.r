# Dealing with Non-Linear Responses

# Logistic regression to predict probs
# sparrow is available
summary(sparrow)

# Create the survived column
sparrow$survived <- (sparrow$status == "Survived")

# Create the formula
(fmla <- as.formula("survived ~ total_length + weight + humerus"))

# Fit the logistic regression model
sparrow_model <- glm(fmla, data = sparrow, family = binomial)

# Call summary
summary(sparrow_model)

# Call glance
(perf <- broom::glance(sparrow_model))

# Calculate pseudo-R-squared
(pseudoR2 <- 1 - perf$deviance / perf$null.deviance)

# sparrow is available
summary(sparrow)

# sparrow_model is available
summary(sparrow_model)

# Make predictions
sparrow$pred <- predict(sparrow_model, data = sparrow, type = "response")

# Look at gain curve. 
# If the model's gain curve is close to the ideal ("wizard") gain curve, then the model sorted the sparrows well: that is, 
# the model predicted that sparrows that actually survived would have a higher probability of survival.
GainCurvePlot(sparrow, "pred", "survived", "sparrow survival model")

# Poisson and quasi-poisson
# One of the assumptions of Poisson regression to predict counts is that the event you are counting is Poisson distributed: the average 
# count per unit time is the same as the variance of the count. In practice, "the same" means that the mean and the variance should
# be of a similar order of magnitude.

# When the variance is much larger than the mean, the Poisson assumption doesn't apply, and one solution is to use quasipoisson regression, 
# which does not assume that "mean = variance".

# bikesJuly is available
str(bikesJuly)

# The outcome column. String of the outcome variable name
outcome 

# The inputs to use. List of string values for the variables in the data frame
vars 

# Create the formula string for bikes rented as a function of the inputs. paste() used to concatenate the strings
(fmla <- paste(outcome, "~", paste(vars, collapse = " + ")))

# Calculate the mean and variance of the outcome. As the mean != variance with a similar magnitude the quasipoisson is used
(mean_bikes <- mean(bikesJuly$cnt))
(var_bikes <- var(bikesJuly$cnt))

# Fit the model
bike_model <- glm(fmla, data = bikesJuly, family = quasipoisson)

# Call glance
(perf <- broom::glance(bike_model))

# Calculate pseudo-R-squared
(pseudoR2 <- 1 - perf$deviance / perf$null.deviance)

# Predict bike rentals on new data
# bikesAugust is available
str(bikesAugust)

# bike_model is available
summary(bike_model)

# Make predictions on August data
bikesAugust$pred  <- predict(bike_model, newdata = bikesAugust, type = "response")

# Calculate the RMSE
bikesAugust %>% 
  mutate(residual = cnt - pred) %>%
  summarize(rmse  = sqrt(mean(residual ^ 2)))

# Plot predictions vs cnt (pred on x-axis)
ggplot(bikesAugust, aes(x = pred, y = cnt)) +
  geom_point() + 
  geom_abline(color = "darkblue")

# Visualize the bike rentals by a time series
# Plot predictions and cnt by date/time
bikesAugust %>% 
  # set start to 0, convert unit to days
  mutate(instant = (instant - min(instant))/24) %>%  
  # gather cnt and pred into a value column
  gather(key = valuetype, value = value, cnt, pred) %>%
  filter(instant < 14) %>% # restric to first 14 days
  # plot value by instant
  ggplot(aes(x = instant, y = value, color = valuetype, linetype = valuetype)) + 
  geom_point() + 
  geom_line() + 
  scale_x_continuous("Day", breaks = 0:14, labels = 0:14) + 
  scale_color_brewer(palette = "Dark2") + 
  ggtitle("Predicted August bike rentals, Quasipoisson model")

# GAM to learn non-linear transforms
# When using gam() to model outcome as an additive function of the inputs, you can use the s() function inside formulas to 
# designate that you want to use a spline to model the non-linear relationship of a continuous variable to the outcome.
# The s() function is best applied to continuous variables with > 10 values.
# It is a good function to learn which power the spline should take to fit the data. Also helps when domain knowledge is not available.

# Load the package mgcv
library(mgcv)

# Create the formula 
(fmla.gam <- as.formula("weight ~ s(Time)") )

# Fit the GAM Model
model.gam <- gam(fmla.gam, family = gaussian, data = soybean_train)

# Call summary() on model.lin and look for R-squared
summary(model.lin)

# Call summary() on model.gam and look for R-squared
summary(model.gam)

# Call plot() on model.gam. The Generalized Additive Model fits the data much better
plot(model.gam)

# Predict with soybean on test data. Comparison of the linear and GAM model outputs
# soybean_test is available
summary(soybean_test)

# Get predictions from linear model
soybean_test$pred.lin <- predict(model.lin, newdata = soybean_test)

# Get predictions from gam model. As the gam model returns a matrix with the predict function, as.numeric() converts to a vector
soybean_test$pred.gam <- as.numeric(predict(model.gam, newdata = soybean_test))

# Gather the predictions into a "long" dataset
soybean_long <- soybean_test %>%
  gather(key = modeltype, value = pred, pred.lin, pred.gam)

# Calculate the rmse
soybean_long %>%
  mutate(residual = weight - pred) %>%     # residuals
  group_by(modeltype) %>%                  # group by modeltype
  summarize(rmse = sqrt(mean(residual ^ 2))) # calculate the RMSE

# Compare the predictions against actual weights on the test data
soybean_long %>%
  ggplot(aes(x = Time)) +                          # the column for the x axis
  geom_point(aes(y = weight)) +                    # the y-column for the scatterplot
  geom_point(aes(y = pred, color = modeltype)) +   # the y-column for the point-and-line plot
  geom_line(aes(y = pred, color = modeltype, linetype = modeltype)) + # the y-column for the point-and-line plot
  scale_color_brewer(palette = "Dark2")
  
