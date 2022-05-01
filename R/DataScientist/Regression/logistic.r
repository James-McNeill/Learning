# Logistic regression

# Using real-world data, you’ll predict the likelihood of a customer closing their bank account as 
# probabilities of success and odds ratios, and quantify model performance using confusion matrices.

# Using churn, plot time_since_last_purchase
ggplot(churn, aes(time_since_last_purchase)) +
  # as a histogram with binwidth 0.25
  geom_histogram(binwidth = 0.25) +
  # faceted in a grid with has_churned on each row
  facet_grid(vars(has_churned))

# Using churn plot has_churned vs. time_since_first_purchase
ggplot(churn, aes(time_since_first_purchase, has_churned)) +
  # Make it a scatter plot
  geom_point() +
  # Add an lm trend line, no std error ribbon, colored red
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  # Add a glm trend line, no std error ribbon, binomial family
  geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"))

# Fit a logistic regression of churn vs. length of relationship using the churn dataset. The same method can be used to fit a linear regression model, the only
# adjustment is to change family to "gaussian"
mdl_churn_vs_relationship <- glm(
    has_churned ~ time_since_first_purchase,
    data = churn,
    family = "binomial"
)

# See the result
mdl_churn_vs_relationship
