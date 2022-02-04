# Technical indicators

# A. Trend indicator MAs
# A 12-period EMA and 26-period EMA are two moving averages used in calculating a more complex indicator called 
# MACD (Moving Average Convergence Divergence). The MACD turns two EMAs into a momentum indicator by subtracting
# the longer EMA from the shorter one.
# 1. Calculate and plot two EMAs
# Calculate 12-day EMA
stock_data['EMA_12'] = talib.EMA(stock_data['Close'], timeperiod=12)
# Calculate 26-day EMA
stock_data['EMA_26'] = talib.EMA(stock_data['Close'], timeperiod=26)

# Plot the EMAs with price
plt.plot(stock_data['EMA_12'], label='EMA_12')
plt.plot(stock_data['EMA_26'], label='EMA_26')
plt.plot(stock_data['Close'], label='Close')

# Customize and show the plot
plt.legend()
plt.title('EMAs')
plt.show()

