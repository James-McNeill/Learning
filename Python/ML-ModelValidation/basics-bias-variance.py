# Bias Vs Variance tradeoff

# High variance relates to overfitting the model on training data and performing poorly on test data
# High bias relates to underfitting the model on both training and test data

# Aim is to ensure that the model generalizes well to both training and test data with accuracy metrics
# relatively close together.

# Adjust the model params to understand the sensitivity of the model predictions
# n_estimators: number trees [100, 25]
# max_features: features used [2, 11, 4]
# Update the rfr model
rfr = RandomForestRegressor(n_estimators=25,
                            random_state=1111,
                            max_features=4)
rfr.fit(X_train, y_train)

# Print the training and testing accuracies 
print('The training error is {0:.2f}'.format(
  mae(y_train, rfr.predict(X_train))))
print('The testing error is {0:.2f}'.format(
  mae(y_test, rfr.predict(X_test))))
