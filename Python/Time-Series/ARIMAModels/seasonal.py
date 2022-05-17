# Seasonal ARIMA model

# Seasonal decompose
# You can think of a time series as being composed of trend, seasonal and residual components

# Import seasonal decompose
from statsmodels.tsa.seasonal import seasonal_decompose

# Perform additive decomposition
decomp = seasonal_decompose(milk_production['pounds_per_cow'], 
                            period=12)

# Plot decomposition
decomp.plot()
plt.show()

# Seasonal ACF and PACF
# The ACF can be used to understand the length of seasonality within the time series. When the data is stationary the ACF plot can be used.
# From the initial ACF we can see that the time series is not stationary
# Create figure and subplot
fig, ax1 = plt.subplots()

# Plot the ACF on ax1
plot_acf(water['water_consumers'], lags=25, zero=False,  ax=ax1)

# Show figure
plt.show()

# Subtract the rolling mean. From the first ACF plot we can see that the values turn negative at time period 15, so using this as the rolling mean
# is a good starting place.
water_2 = water - water.rolling(15).mean()

# Drop the NaN values
water_2 = water_2.dropna()

# Create figure and subplots
fig, ax1 = plt.subplots()

# Plot the ACF. This new ACF shows that when the data point is outside the confidence window then this is the appropriate seasonal time period
plot_acf(water_2['water_consumers'], lags=25, zero=False, ax=ax1)

# Show figure
plt.show()

# Seasonal ARIMA models
# Create a SARIMAX model
model = SARIMAX(df1, order=(1,0,0), seasonal_order=(1,1,0,7)) # seasonal_order=(P,D,Q,S), seasonal values for the three original parameters, then S is the seasonal step

# Fit the model
results = model.fit()

# Print the results summary
print(results.summary())

# Create a SARIMAX model
model = SARIMAX(df3, order=(1,1,0), seasonal_order=(0,1,1,12))

# Fit the model
results = model.fit()

# Print the results summary
print(results.summary())

# Choosing SARIMA order
# Take the first and seasonal differences and drop NaNs
aus_employment_diff = aus_employment.diff(1).diff(12).dropna()

# Plot Non-Seasonal figures
# Create the figure 
fig, (ax1, ax2) = plt.subplots(2,1,figsize=(8,6))

# Plot the ACF on ax1
plot_acf(aus_employment_diff, lags=11, zero=False, ax=ax1)

# Plot the PACF on ax2
plot_pacf(aus_employment_diff, lags=11, zero=False, ax=ax2)

plt.show()

# Plot Seasonal figures
# Make list of lags
lags = [12, 24, 36, 48, 60]

# Create the figure 
fig, (ax1, ax2) = plt.subplots(2,1,figsize=(8,6))

# Plot the ACF on ax1
plot_acf(aus_employment_diff, lags=lags, zero=False, ax=ax1)

# Plot the PACF on ax2
plot_pacf(aus_employment_diff, lags=lags, zero=False, ax=ax2)

plt.show()

# SARIMA vs ARIMA forecasts
# Create ARIMA mean forecast
arima_pred = arima_results.get_forecast(steps=25, dynamic=True)
arima_mean = arima_pred.predicted_mean

# Create SARIMA mean forecast
sarima_pred = sarima_results.get_forecast(steps=25, dynamic=True)
sarima_mean = sarima_pred.predicted_mean

# Plot mean ARIMA and SARIMA predictions and observed. The Seasonal forecast captures this element much better than the regular ARIMA forecast which only
# detects the upward trend
plt.plot(dates, sarima_mean, label='SARIMA')
plt.plot(dates, arima_mean, label='ARIMA')
plt.plot(wisconsin_test, label='observed')
plt.legend()
plt.show()
