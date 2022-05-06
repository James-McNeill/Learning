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

# unemployment is available
summary(unemployment)

# unemployment_model is available
summary(unemployment_model)

# Calculate and print the mean female_unemployment: fe_mean
(fe_mean <- mean(unemployment$female_unemployment))

# Calculate and print the total sum of squares: tss
(tss <- sum((unemployment$female_unemployment - fe_mean)^2))

# Calculate and print residual sum of squares: rss
(rss <- sum((unemployment$female_unemployment - unemployment$predictions)^2))

# Calculate and print the R-squared: rsq
(rsq <- 1 - (rss / tss))

# Get R-squared from glance and print it
(rsq_glance <- glance(unemployment_model)$r.squared)

# unemployment is available
summary(unemployment)

# unemployment_model is available
summary(unemployment_model)

# Get the correlation between the prediction and true outcome: rho and print it
(rho <- cor(unemployment$female_unemployment, unemployment$predictions))

# Square rho: rho2 and print it
(rho2 <- rho ^ 2)

# Get R-squared from glance and print it
(rsq_glance <- glance(unemployment_model)$r.squared)

# Randomly splitting the data into test/train
# mpg is available
summary(mpg)
dim(mpg)

# Use nrow to get the number of rows in mpg (N) and print it
(N <- nrow(mpg))

# Calculate how many rows 75% of N should be and print it
# Hint: use round() to get an integer
(target <- round(N * 0.75))

# Create the vector of N uniform random variables: gp
gp <- runif(N)

# Use gp to create the training set: mpg_train (75% of data) and mpg_test (25% of data)
mpg_train <- mpg[gp < 0.75,]
mpg_test <- mpg[gp >= 0.75,]

# Use nrow() to examine mpg_train and mpg_test
nrow(mpg_train)
nrow(mpg_test)

# mpg_train is available
summary(mpg_train)

# Create a formula to express cty as a function of hwy: fmla and print it.
(fmla <- as.formula("cty ~ hwy"))
fmla

# Now use lm() to build a model mpg_model from mpg_train that predicts cty from hwy 
mpg_model <- lm(fmla, data = mpg_train)

# Use summary() to examine the model
summary(mpg_model)

# Examine the objects that have been loaded
ls.str()

# predict cty from hwy for the training set
mpg_train$pred <- predict(mpg_model, mpg_train)

# predict cty from hwy for the test set
mpg_test$pred <- predict(mpg_model, mpg_test)

# Evaluate the rmse on both training and test data and print them
(rmse_train <- rmse(mpg_train$pred, mpg_train$cty))
(rmse_test <- rmse(mpg_test$pred, mpg_test$cty))


# Evaluate the r-squared on both training and test data.and print them
(rsq_train <- r_squared(mpg_train$pred, mpg_train$cty))
(rsq_test <- r_squared(mpg_test$pred, mpg_test$cty))

# Plot the predictions (on the x-axis) against the outcome (cty) on the test data
ggplot(mpg_test, aes(x = pred, y = cty)) + 
  geom_point() + 
  geom_abline()

# Create a cross validation plan
# Load the package vtreat
library(vtreat)

# mpg is available
summary(mpg)

# Get the number of rows in mpg
nRows <- nrow(mpg)

# Implement the 3-fold cross-fold plan with vtreat
# kWayCrossValidation(nRows, nSplits, dframe, y)
# nRows: rows within data frame
# nSplits: splits to perform
# last two params can be set to NULL
# The resulting splitPlan is a list of nSplits elements; each element contains two vectors:
# train: the indices of dframe that will form the training set
# app: the indices of dframe that will form the test (or application) set
splitPlan <- kWayCrossValidation(nRows, 3, NULL, NULL)

# Examine the split plan
str(splitPlan)

# Evaluating performance using n-fold cross validation
# mpg is available
summary(mpg)

# splitPlan is available
str(splitPlan)

# Run the 3-fold cross validation plan from splitPlan
k <- 3 # Number of folds
mpg$pred.cv <- 0 
for(i in 1:k) {
  split <- splitPlan[[i]]
  model <- lm(cty ~ hwy, data = mpg[split$train,])
  mpg$pred.cv[split$app] <- predict(model, newdata = mpg[split$app,])
}

# Predict from a full model
mpg$pred <- predict(lm(cty ~ hwy, data = mpg))

# Get the rmse of the full model's predictions
rmse(mpg$pred, mpg$cty)

# Get the rmse of the cross-validation predictions
rmse(mpg$pred.cv, mpg$cty)
