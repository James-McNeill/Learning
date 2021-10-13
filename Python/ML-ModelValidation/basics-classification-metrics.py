# Classification Metrics
# Working with the confusion matrix to understand model performance

# Matrix is designed as Actuals (Index (axis=0)) Vs Predicted (Features (axis=1))
# Matrix: [[0, 1], [0, 1]]
# TN: [0, 0]
# FP: [0, 1]
# FN: [1, 0]
# TP: [1, 1]

# Calculate and print the accuracy
accuracy = (TN + TP) / (Total)
print("The overall accuracy is {0: 0.2f}".format(accuracy))

# Calculate and print the precision
precision = (TP) / (FP + TP)
print("The precision is {0: 0.2f}".format(precision))

# Calculate and print the recall
recall = (TP) / (FN + TP)
print("The recall is {0: 0.2f}".format(recall))

# 1. Method from sklearn module
from sklearn.metrics import confusion_matrix

# Create predictions
test_predictions = rfc.predict(X_test)

# Create and print the confusion matrix
cm = confusion_matrix(y_test, test_predictions)
print(cm)

# Print the true positives (actual 1s that were predicted 1s)
print("The number of true positives is: {}".format(cm[1, 1]))

# 2. Precision score
from sklearn.metrics import precision_score

test_predictions = rfc.predict(X_test)

# Create precision or recall score based on the metric you imported
score = precision_score(y_test, test_predictions)

# Print the final result
print("The precision value is {0:.2f}".format(score))
