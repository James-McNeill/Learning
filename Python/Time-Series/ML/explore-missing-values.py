# Working with missing values in Time Series
# Reviewing the stock prices over time

# Visualize the dataset
prices.plot(legend=False)
plt.tight_layout()
plt.show()

# Count the missing values of each time series
missing_values = prices.isnull().sum()
print(missing_values)
