# Understanding regression

# Working with Linear regression
# unemployment is available
summary(unemployment)

# Define a formula to express female_unemployment as a function of male_unemployment
fmla <- as.formula("female_unemployment ~ male_unemployment")

# Print it
fmla

# Use the formula to fit a model: unemployment_model
unemployment_model <- lm(fmla, data = unemployment)

# Print it
unemployment_model

# Examining a model
# Print unemployment_model
unemployment_model

# Call summary() on unemployment_model to get more details
summary(unemployment_model)

# Call glance() on unemployment_model to see the details in a tidier form
broom::glance(unemployment_model)

# Call wrapFTest() on unemployment_model to see the most relevant details
sigr::wrapFTest(unemployment_model)

# unemployment is available
summary(unemployment)

# newrates is available
newrates

# Predict female unemployment in the unemployment dataset
unemployment$prediction <-  predict(unemployment_model, data = newrates)

# Load the ggplot2 package
library(ggplot2)

# Make a plot to compare predictions to actual (prediction on x axis). 
ggplot(unemployment, aes(x = prediction, y = female_unemployment)) + 
  geom_point() +
  geom_abline(color = "blue")

# Predict female unemployment rate when male unemployment is 5%
pred <- predict(unemployment_model, data.frame(male_unemployment = 5))
pred

# bloodpressure is available
summary(bloodpressure)

# Create the formula and print it
fmla <- as.formula("blood_pressure ~ age + weight")
fmla

# Fit the model: bloodpressure_model
bloodpressure_model <- lm(fmla, data = bloodpressure)

# Print bloodpressure_model and call summary() 
bloodpressure_model
summary(bloodpressure_model)
