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
