# Technical indicators

# A. Trend indicator MAs
# A 12-period EMA and 26-period EMA are two moving averages used in calculating a more complex indicator called 
# MACD (Moving Average Convergence Divergence). The MACD turns two EMAs into a momentum indicator by subtracting
# the longer EMA from the shorter one.

# TA-lib: Technical analysis library. 
# Includes 150+ technical indicator implementations
import talib

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

# 2. SMA vs EMA
# Calculate the SMA
stock_data['SMA'] = talib.SMA(stock_data['Close'], timeperiod=50)
# Calculate the EMA
stock_data['EMA'] = talib.EMA(stock_data['Close'], timeperiod=50)

# Plot the SMA, EMA with price
plt.plot(stock_data['SMA'], label='SMA')
plt.plot(stock_data['EMA'], label='EMA')
plt.plot(stock_data['Close'], label='Close')

# Customize and show the plot
plt.legend()
plt.title('SMA vs EMA')
plt.show()
