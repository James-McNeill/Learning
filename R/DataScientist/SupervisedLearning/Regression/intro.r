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
