# Performing the cross validation process with the shuffling aspect switched off. By neutralising
# the shuffling parameter, this ensures that neighbouring data points will be kept together. It is
# this time dependence for the cross validation process that really helps to maintain the temporal
# dementionality of the time series data.

# Create KFold cross-validation object
from sklearn.model_selection import KFold
cv = KFold(n_splits=10, shuffle=False, random_state=1)

# Iterate through CV splits
results = []
for tr, tt in cv.split(X, y):
    # Fit the model on training data
    model.fit(X[tr], y[tr])
    
    # Generate predictions on the test data and collect
    prediction = model.predict(X[tt])
    results.append((prediction, tt))
    
# Custom function to quickly visualize predictions
visualize_predictions(results)
