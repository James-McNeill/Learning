# Fitting time series models

# Fitting AR and MA models
# Instantiate the model. ARMA(2,0) -> AR(2)
model = ARMA(sample['timeseries_1'], order=(2,0))

# Fit the model
results = model.fit()

# Print summary. From the model coefficients we can understand which parameters where placed in the arma_generate_sample() function.
# With the AR coefficients, remember that these are keyed in as negative values. So if the formula requires a positive value, then the arma_generate_sample
# function would require a negative value to create this positive. It is just a querk with the function code
print(results.summary())

# Instantiate the model. ARMA(0, 3) -> MA(3)
model = ARMA(sample['timeseries_2'], order=(0, 3))

# Fit the model
results = model.fit()

# Print summary
print(results.summary())
