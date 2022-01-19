# Regression
# Create Linear Regression models. You'll also find out how to augment your data by engineering new 
# predictors as well as a robust approach to selecting only the most relevant predictors.

# A. One hot encoding
# 1. Encoding flight origin
# Import the one hot encoder class
from pyspark.ml.feature import OneHotEncoderEstimator

# Create an instance of the one hot encoder
onehot = OneHotEncoderEstimator(inputCols=['org_idx'], outputCols=['org_dummy'])

# Apply the one hot encoder to the flights data
onehot = onehot.fit(flights)
flights_onehot = onehot.transform(flights)

# Check the results. Note that the final category doesn't receive a value as it will be the remaining group if no other dummy value has been assigned
flights_onehot.select('org', 'org_idx', 'org_dummy').distinct().sort('org_idx').show()
