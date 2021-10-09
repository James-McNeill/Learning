# Performing a standard shuffle split cross validation algorithm.
# Data has already been created for the model. Also a helper function has been
# generated to help show the visualiztion's of the predictions.

# Import ShuffleSplit and create the cross-validation object
from sklearn.model_selection import ShuffleSplit
cv = ShuffleSplit(10, random_state=1)

# Iterate through CV splits
results = []
for tr, tt in cv.split(X, y):
    # Fit the model on training data
    model.fit(X[tr], y[tr])
    
    # Generate predictions on the test data, score the predictions, and collect
    prediction = model.predict(X[tt])
    score = r2_score(y[tt], prediction)
    results.append((prediction, score, tt))

# Custom function to quickly visualize predictions
visualize_predictions(results)

# Conclusion - challenge with this methodology is that it expects
# the data points to be i.i.d, which is not common within time series data as there will be some information
# contained within the closest data points.
