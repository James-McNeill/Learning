# Decision Trees

# Classification trees use flowchart-like structures to make decisions. Because humans can readily understand these 
# tree structures, classification trees are useful when transparency is needed, such as in loan approval. 
# We'll use the Lending Club dataset to simulate this scenario

# Simple model
# Load the rpart package
library(rpart)

# Build a lending model predicting loan outcome versus loan amount and credit score
loan_model <- rpart(outcome ~ loan_amount + credit_score, data = loans, method = "class", control = rpart.control(cp = 0))

# Make a prediction for someone with good credit
predict(loan_model, good_credit, type = "class")

# Make a prediction for someone with bad credit
predict(loan_model, bad_credit, type = "class")

# Visualize the tree
# Examine the loan_model object
loan_model

# Load the rpart.plot package
library(rpart.plot)

# Plot the loan_model with default settings
rpart.plot(loan_model)

# Plot the loan_model with customized settings
rpart.plot(loan_model, type = 3, box.palette = c("red", "green"), fallen.leaves = TRUE)

# Creating a random sample for Train and Test sets
# Determine the number of rows for training
nrow(loans)

# Create a random sample of row IDs
sample_rows <- sample(nrow(loans), nrow(loans) * 0.75)

# Create the training dataset
loans_train <- loans[sample_rows,]

# Create the test dataset
loans_test <- loans[-sample_rows,]

# Build and evaluate the tree
# Grow a tree using all of the available applicant data
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0))

# Make predictions on the test dataset
loans_test$pred <- predict(loan_model, loans_test, type = "class")

# Examine the confusion matrix
table(loans_test$outcome, loans_test$pred)

# Compute the accuracy on the test dataset
mean(loans_test$outcome == loans_test$pred)

# Preventing overgrown trees
# Grow a tree with maxdepth of 6. rpart.control() allows for hyperparameter tuning
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(maxdepth = 6, cp = 0))

# Make a class prediction on the test set
loans_test$pred <- predict(loan_model, loans_test, type = "class")

# Compute the accuracy of the simpler tree
mean(loans_test$outcome == loans_test$pred)

# Swap maxdepth for a minimum split of 500. This results in each leaf having a minimum of 500 observations. The tree will not split the node any further
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0, minsplit = 500))

# Run this. How does the accuracy change?
loans_test$pred <- predict(loan_model, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)

# Using post pruning
# Grow an overly complex tree
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0))

# Examine the complexity plot
plotcp(loan_model)

# Prune the tree. After reviewing the visualization from plotcp() we are able to prune values at the elbow point below hashed line
loan_model_pruned <- prune(loan_model, cp = 0.0014)

# Compute the accuracy of the pruned tree. Model accuracy has improved
loans_test$pred <- predict(loan_model_pruned, loans_test, type = "class")
mean(loans_test$outcome == loans_test$pred)
