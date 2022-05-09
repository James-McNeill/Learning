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
