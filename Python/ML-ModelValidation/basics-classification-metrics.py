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
