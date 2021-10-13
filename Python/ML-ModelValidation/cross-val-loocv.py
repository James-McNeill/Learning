# Leave-one-out-cross-validation (LOOCV)
# As the method leaves one data point out each time the method works best for
# smaller datasets with number of observations less than 1000 for example

# Import the modules
from sklearn.metrics import mean_absolute_error, make_scorer

# Create scorer
mae_scorer = make_scorer(mean_absolute_error)

rfr = RandomForestRegressor(n_estimators=15, random_state=1111)

# Implement LOOCV - setting cv to the number of observations
scores = cross_val_score(rfr, X=X, y=y, cv=X.shape[0], scoring=mae_scorer)

# Print the mean and standard deviation
print("The mean of the errors is: %s." % np.mean(scores))
print("The standard deviation of the errors is: %s." % np.std(scores))
