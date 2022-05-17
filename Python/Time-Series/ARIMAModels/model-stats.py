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
