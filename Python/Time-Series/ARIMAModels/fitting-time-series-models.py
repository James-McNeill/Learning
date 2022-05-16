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

# Fitting ARMA model
# Instantiate the model. ARMA(3, 1)
model = ARMA(earthquake, order = (3, 1))

# Fit the model
results = model.fit()

# Print model fit summary
print(results.summary())

# Fitting an ARMAX model
# Instantiate the model
model = ARMA(hospital['wait_times_hrs'], order=(2,1), exog=hospital['nurse_count'])

# Fit the model
results = model.fit()

# Print model fit summary
print(results.summary())

# Generate one-step ahead predictions
# Generate predictions
one_step_forecast = results.get_prediction(start=-30)

# Extract prediction mean
mean_forecast = one_step_forecast.predicted_mean

# Get confidence intervals of  predictions
confidence_intervals = one_step_forecast.conf_int()

# Select lower and upper confidence limits
lower_limits = confidence_intervals.loc[:,'lower close']
upper_limits = confidence_intervals.loc[:,'upper close']

# Print best estimate  predictions
print(mean_forecast)

# Plotting one-step ahead predictions
# plot the amazon data
plt.plot(amazon.index, amazon, label='observed')

# plot your mean predictions
plt.plot(mean_forecast.index, mean_forecast, color='r', label='forecast')

# shade the area between your confidence limits
plt.fill_between(lower_limits.index, lower_limits,
		 upper_limits, color='pink')

# set labels, legends and show plot
plt.xlabel('Date')
plt.ylabel('Amazon Stock Price - Close USD')
plt.legend()
plt.show()

# Generating dynamic forecasts
# Making predictions over a longer period of time relates to dynamic predictions. With these longer predictions the error term increases
# and therefore the accuracy will fall.
# Generate predictions
dynamic_forecast = results.get_prediction(start=-30, dynamic=True)

# Extract prediction mean
mean_forecast = dynamic_forecast.predicted_mean

# Get confidence intervals of predictions
confidence_intervals = dynamic_forecast.conf_int()

# Select lower and upper confidence limits
lower_limits = confidence_intervals.loc[:,'lower close']
upper_limits = confidence_intervals.loc[:,'upper close']

# Print best estimate predictions
print(mean_forecast)

# Plotting dynamic forecasts
# plot the amazon data
plt.plot(amazon.index, amazon, label='observed')

# plot your mean forecast
plt.plot(mean_forecast.index, mean_forecast, color='r', label='forecast')

# shade the area between your confidence limits
plt.fill_between(lower_limits.index, lower_limits, 
         upper_limits, color='pink')

# set labels, legends and show plot
plt.xlabel('Date')
plt.ylabel('Amazon Stock Price - Close USD')
plt.legend()
plt.show()
