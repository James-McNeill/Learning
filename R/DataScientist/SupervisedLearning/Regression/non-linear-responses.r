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
