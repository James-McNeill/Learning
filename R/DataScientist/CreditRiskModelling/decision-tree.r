# Decision Trees
# Classification trees are another popular method in the world of credit risk modeling.

# Computing the gin for a tree
# The Gini-measure of the root node is given below
gini_root <- 2 * 89 / 500 * 411 / 500

# Compute the Gini measure for the left leaf node
gini_ll <- 2 * 401 / 446 * 45 / 446

# Compute the Gini measure for the right leaf node
gini_rl <- 2 * 10 / 54 * 44 / 54

# Compute the gain
gain <- gini_root - 446 / 500 * gini_ll - 54 / 500 * gini_rl

# compare the gain-column in small_tree$splits with our computed gain, multiplied by 500, and assure they are the same
small_tree$splits
improve <- gain * 500

# Undersampling the training set
# The challenge with the unbalanced default status, is that the decision tree will aim to provide the optimal solution. This solution would
# be to associate all predictions to non-default. In order to overcome this there are a number of options; 1) under/oversample, 2) changin prior probs, 
# and 3) including a loss matrix. Each method aims to force the tree to make splits that search for the unbalanced segment (default status)

# The undersampled training data consists of 1/3 defaults and 2/3 non-default. Encourages the decision tree to search more for the default / non-default split
# Load package rpart in your workspace.
library(rpart)

# Change the code provided in the video such that a decision tree is constructed using the undersampled training set. Include rpart.control to relax the complexity parameter to 0.001.
tree_undersample <- rpart(loan_status ~ ., method = "class",
                          data =  undersampled_training_set,
                          control = rpart.control(cp = 0.001)) # cp: complexity parameter, threshold for a decrease in overall lack of fit for a split. To high, not enough splits

# Plot the decision tree
plot(tree_undersample, uniform = TRUE)

# Add labels to the decision tree
text(tree_undersample)

# Changing prior probabilities
# Change the code below such that a tree is constructed with adjusted prior probabilities.
tree_prior <- rpart(loan_status ~ ., method = "class",
                    data = training_set, parms = list(prior=c(0.7, 0.3)), # c(non-default proportion, default proportion)
                    control = rpart.control(cp = 0.001))

# Plot the decision tree
plot(tree_prior, uniform = TRUE)

# Add labels to the decision tree
text(tree_prior)

# Including a loss matrix
# Change the code below such that a decision tree is constructed using a loss matrix penalizing 10 times more heavily for misclassified defaults.
tree_loss_matrix <- rpart(loan_status ~ ., method = "class",
                          data =  training_set, parms = list(loss = matrix(c(0, 10, 1, 0), ncol = 2)), # c(0, cost_def_as_nondef, cost_nondef_as_def, 0) (TN, FP, FN, TP)
                          control = rpart.control(cp = 0.001))


# Plot the decision tree
plot(tree_loss_matrix, uniform = TRUE)

# Add labels to the decision tree
text(tree_loss_matrix)

# Pruning decision trees
# tree_prior is loaded in your workspace

# Plot the cross-validated error rate as a function of the complexity parameter. Aiming to select the cp value that results in the minimum xerror
plotcp(tree_prior)

# Use printcp() to identify for which complexity parameter the cross-validated error rate is minimized.
printcp(tree_prior)

# Create an index for of the row with the minimum xerror
index <- which.min(tree_prior$cptable[ , "xerror"])

# Create tree_min
tree_min <- tree_prior$cptable[index, "CP"]

#  Prune the tree using tree_min
ptree_prior <- prune(tree_prior, cp = tree_min)

# Use prp() to plot the pruned tree
prp(ptree_prior)

# Pruning tree with loss matrix
# set a seed and run the code to construct the tree with the loss matrix again
set.seed(345)
tree_loss_matrix  <- rpart(loan_status ~ ., method = "class", data = training_set,
                           parms = list(loss=matrix(c(0, 10, 1, 0), ncol = 2)),
                           control = rpart.control(cp = 0.001))

# Plot the cross-validated error rate as a function of the complexity parameter
plotcp(tree_loss_matrix)

# Prune the tree using cp = 0.0012788
ptree_loss_matrix <- prune(tree_loss_matrix, cp = 0.0012788)

# Use prp() and argument extra = 1 to plot the pruned tree
prp(ptree_loss_matrix, extra = 1)

# Pruning trees with more options
# set a seed and run the code to obtain a tree using weights, minsplit and minbucket
set.seed(345)
tree_weights <- rpart(loan_status ~ ., method = "class",
                      data = training_set,
                      weights = case_weights, # a vector with more weight applied to the default cases. default has value = 3 and non-default = 1
                      control = rpart.control(minsplit = 5, minbucket = 2, cp = 0.001)) # minsplit: min number of splits, minbucket: min number of observations

# Plot the cross-validated error rate for a changing cp
plotcp(tree_weights)

# Create an index for of the row with the minimum xerror
index <- which.min(tree_weights$cp[ , "xerror"])

# Create tree_min
tree_min <- tree_weights$cp[index, "CP"]

# Prune the tree using tree_min
ptree_weights <- prune(tree_weights, cp = tree_min)

# Plot the pruned tree using the rpart.plot()-package
prp(ptree_weights, extra = 1)

# Confusion matrix and accuracy
# Make predictions for each of the pruned trees using the test set.
pred_undersample <- predict(ptree_undersample, newdata = test_set,  type = "class")
pred_prior <- predict(ptree_prior, newdata = test_set,  type = "class")
pred_loss_matrix <- predict(ptree_loss_matrix, newdata = test_set,  type = "class")
pred_weights <- predict(ptree_weights, newdata = test_set,  type = "class")

# construct confusion matrices using the predictions.
confmat_undersample <- table(test_set$loan_status, pred_undersample)
confmat_prior <- table(test_set$loan_status, pred_prior)
confmat_loss_matrix <- table(test_set$loan_status, pred_loss_matrix)
confmat_weights <- table(test_set$loan_status, pred_weights)

# Compute the accuracies. The loss matrix accuracy was very far from the other three, showing much weaker performance
acc_undersample <- sum(diag(confmat_undersample)) / nrow(test_set)
acc_prior <- sum(diag(confmat_prior)) / nrow(test_set)
acc_loss_matrix <- sum(diag(confmat_loss_matrix)) / nrow(test_set)
acc_weights <- sum(diag(confmat_weights)) / nrow(test_set)
