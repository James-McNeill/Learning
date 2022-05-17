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

# Automation and saving model selections
# Import pmdarima as pm
# Automatically choose model orders for some time series datasets
import pmdarima as pm

# Create auto_arima model
# Model the time series df1 with period 7 days and set first order seasonal differencing and no non-seasonal differencing.
model1 = pm.auto_arima(df1,
                      seasonal=True, m=7,
                      d=0, D=1, 
                 	  max_p=2, max_q=2,
                      trace=True,
                      error_action='ignore',
                      suppress_warnings=True) 

# Print model summary
print(model1.summary())

# Create model
# Create a model to fit df2. Set the non-seasonal differencing to 1, the trend to a constant and set no seasonality.
model2 = pm.auto_arima(df2,
                      seasonal=False,
                      d=1,
                      trend='c',
                 	  max_p=2, max_q=2,
                      trace=True,
                      error_action='ignore',
                      suppress_warnings=True) 

# Print model summary
print(model2.summary())

# Create model for SARIMAX(p,1,q)(P,1,Q)7
model3 = pm.auto_arima(df3,
                      seasonal=True, m=7,
                      d=1, D=1, 
                      start_p=1, start_q=1,
                      max_p=1, max_q=1,
                      max_P=1, max_Q=1,
                      trace=True,
                      error_action='ignore',
                      suppress_warnings=True) 

# Print model summary
print(model3.summary())

# Saving and updating models
# Import joblib
import joblib

# Set model name
filename = "candy_model.pkl"

# Pickle it
joblib.dump(model,filename)

# Load the model back in
loaded_model = joblib.load(filename)

# Update the model. Adding new data points to the model. The model will then be updated and aims to make updated predictions with the additional data.
# This can help with monitoring steps. However, if the model stats need to be reviewed again, it might make more sense to follow the Box-Jenkins models again.
loaded_model.update(df_new)

# Model diagnostics
# Import model class
from statsmodels.tsa.statespace.sarimax import SARIMAX

# Create model object
model = SARIMAX(co2, 
                order=(1,1,1), 
                seasonal_order=(0,1,1,12), 
                trend='c')
# Fit model
results = model.fit()

# Plot common diagnostics
results.plot_diagnostics()
plt.show()

# SARIMA forecast
# Create forecast object
forecast_object = results.get_forecast(steps=136, dynamic=True)

# Extract predicted mean attribute
mean = forecast_object.predicted_mean

# Calculate the confidence intervals
conf_int = forecast_object.conf_int()

# Extract the forecast dates
dates = mean.index

plt.figure()

# Plot past CO2 levels
plt.plot(co2.index, co2, label='past')

# Plot the prediction means as line
plt.plot(dates, mean, label='predicted')

# Shade between the confidence intervals
plt.fill_between(dates, conf_int['lower CO2_ppm'], conf_int['upper CO2_ppm'], alpha=0.2)

# Plot legend and show figure
plt.legend()
plt.show()

# Print last predicted mean
print(mean.iloc[-1])

# Print last confidence interval
print(conf_int.iloc[-1])
