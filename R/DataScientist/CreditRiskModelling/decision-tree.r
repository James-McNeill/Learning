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

