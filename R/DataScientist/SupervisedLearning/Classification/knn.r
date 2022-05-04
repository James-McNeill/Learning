# Classification with Nearnest Neighbor (k-NN)

# As the kNN algorithm literally "learns by example" it is a case in point for starting to understand supervised machine learning. 
# This chapter will introduce classification while working through the application of kNN to self-driving vehicle road sign recognition.

# Load the 'class' package
library(class)

# Create a vector of labels
sign_types <- signs$sign_type

# Classify the next sign observed
knn(train = signs[-1], test = next_sign, cl = sign_types) # next_sign holds the classification object

# Exploring the traffic sign dataset
# Examine the structure of the signs dataset
str(signs)

# Count the number of signs of each type
table(signs$sign_type)

# Check r10's average red level by sign type
aggregate(r10 ~ sign_type, data = signs, mean)

# Use kNN to identify the test road signs
sign_types <- signs$sign_type
signs_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)

# Create a confusion matrix of the predicted versus actual values
signs_actual <- test_signs$sign_type
table(signs_pred, signs_actual)

# Compute the accuracy
mean(signs_pred == signs_actual)

# Compute the accuracy of the baseline model (default k = 1)
k_1 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types)
mean(signs_actual == k_1)

# Modify the above to set k = 7. This value showed the best accuracy score
k_7 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 7)
mean(signs_actual == k_7)

# Set k = 15 and compare to the above
k_15 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 15)
mean(signs_actual == k_15)

# Seeing how the neighbors voted
# Use the prob parameter to get the proportion of votes for the winning class
sign_pred <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 7, prob = TRUE)

# Get the "prob" attribute from the predicted classes
sign_prob <- attr(sign_pred, "prob")

# Examine the first several predictions
head(sign_pred)

# Examine the proportion of votes for the winning class
head(sign_prob)

# Normalize data points
# define a min-max normalize() function
normalize <- function(x) {
    return ((x - min(x)) / (max(x) - min(x)))
  }

# Normalize a variable. This output can be compared to the original version of the variable
summary(normalize(signs$r1))
