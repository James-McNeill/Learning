# The best of the best models

# Understanding which elements to review and make the best model selection
# ACF and PACF
# Import
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

# Create figure
fig, (ax1, ax2) = plt.subplots(2,1, figsize=(12,8))
 
# Plot the ACF of df
plot_acf(df, lags=10, zero=False, ax=ax1)

# Plot the PACF of df
plot_pacf(df, lags=10, zero=False, ax=ax2)

plt.show()

# Create figure
fig, (ax1, ax2) = plt.subplots(2,1, figsize=(12,8))

# Plot ACF and PACF
plot_acf(earthquake, lags=10, zero=False, ax=ax1)
plot_pacf(earthquake, lags=10, zero=False, ax=ax2)

# Show plot
plt.show()

# Instantiate model
model = SARIMAX(earthquake, order=(1,0,0))

# Train model
results = model.fit()

# Searching through model orders
# Create empty list to store search results
order_aic_bic=[]

# Loop over p values from 0-2
for p in range(3):
  # Loop over q values from 0-2
    for q in range(3):
      	# create and fit ARMA(p,q) model
        model = SARIMAX(df, order=(p, 0, q))
        results = model.fit()
        
        # Append order and results tuple
        order_aic_bic.append((p, q, results.aic, results.bic))

# Choosing order with AIC and BIC
# AIC: aiming to choose the lowest value, which shows the best posible model
# BIC: aiming to choose the lowest value, shows model with the best explantory power. Can make the model easier to explain as well
# Construct DataFrame from order_aic_bic
order_df = pd.DataFrame(order_aic_bic, 
                        columns=['p', 'q', 'AIC', 'BIC'])

# Print order_df in order of increasing AIC
print(order_df.sort_values('AIC'))

# Print order_df in order of increasing BIC. Sometimes the ordering by AIC / BIC can result in different models being choosen. If this happens then
# selection of the model is up to the model developer to decide or business SMEs
print(order_df.sort_values('BIC'))

# AIC and BIC vs ACF and PACF
# Loop over p values from 0-2
for p in range(3):
    # Loop over q values from 0-2
    for q in range(3):
        # Using the try block as the model fit will cause a ValueError if the input is non-stationary
        try:
            # create and fit ARMA(p,q) model
            model = SARIMAX(earthquake, order=(p, 0, q))
            results = model.fit()
            
            # Print order and results
            print(p, q, results.aic, results.bic)
            
        except:
            print(p, q, None, None)     

# Model diagnostics
# Mean absolute error
# Fit model
model = SARIMAX(earthquake, order=(1,0,1))
results = model.fit()

# Calculate the mean absolute error from residuals
mae = np.mean(abs(results.resid))

# Print mean absolute error
print(mae)

# Make plot of time series for comparison
earthquake.plot()
plt.show()

# Diagnostic summary stats
# Create and fit model
model1 = SARIMAX(df, order=(3,0,1))
results1 = model1.fit()

# Print summary
print(results1.summary())

# Summary stats being reviewed
# Test,	Null hypothesis,	P-value name
# Ljung-Box,	There are no correlations in the residual, Prob(Q)
# Jarque-Bera,	The residuals are normally distributed,	Prob(JB)

# Plot diagnostics
# Test,	Good fit
# Standardized residual,	There are no obvious patterns in the residuals
# Histogram plus kde estimate,	The KDE curve should be very similar to the normal distribution
# Normal Q-Q,	Most of the data points should lie on the straight line
# Correlogram,	95% of correlations for lag greater than zero should not be significant

# Create and fit model
model = SARIMAX(df, order=(1,1,1))
results=model.fit()

# Create the 4 diagostics plots
results.plot_diagnostics()
plt.show()

# Box-Jenkins method
# Steps to take when building a time series model
# Raw data -> production model
# 1. Identification: times series stationary, what differencing makes it stationary, what transforms make it stationary, what p and q look good
#    plot time series, ADF tests, transforms and differencing, ACF and PACF plots
# 2. Estimation: train model to get coefficients, choosing models based on AIC and BIC
# 3. Model diagnostics: are the residuals uncorrelated, are residuals normally distrbuted
# 4. Production: once the other steps before have been made and a model decision made then forecasts can take place

# Identification
# Plot time series
savings.plot()
plt.show()

# Run Dicky-Fuller test
result = adfuller(savings['savings'])

# Print test statistic
print(result[0])

# Print p-value
print(result[1])

# Create figure
fig, (ax1, ax2) = plt.subplots(2,1, figsize=(12,8))
 
# Plot the ACF of savings on ax1
plot_acf(savings['savings'], lags=10, zero=False, ax=ax1)

# Plot the PACF of savings on ax2
plot_pacf(savings['savings'], lags=10, zero=False, ax=ax2)

plt.show()
