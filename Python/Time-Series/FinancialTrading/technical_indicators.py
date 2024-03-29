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

# B. Strength indicator: ADX
# ADX: Average directional moving index
# Range: 0 - 100
# <= 25: no trend, > 25: trending market, > 50: strong trending market
# 1. Calculate the ADX
# More sensitivity to shorted time periods
# Calculate the ADX with the default time period
stock_data['ADX_14'] = talib.ADX(stock_data['High'],
                            stock_data['Low'], 
                            stock_data['Close'])

# Calculate the ADX with the time period set to 21
stock_data['ADX_21'] = talib.ADX(stock_data['High'],
                            stock_data['Low'], 
                            stock_data['Close'],
                            timeperiod=21)

# Print the last five rows
print(stock_data.tail())

# 2. Visualize the ADX
# Calculate ADX
stock_data['ADX'] = talib.ADX(stock_data['High'], stock_data['Low'], stock_data['Close'])

# Create subplots
fig, (ax1, ax2) = plt.subplots(2)

# Plot ADX with the price
ax1.set_ylabel('Price')
ax1.plot(stock_data['Close'])
ax2.set_ylabel('ADX')
ax2.plot(stock_data['ADX'], color='red')

ax1.set_title('Price and ADX')
plt.show()

# C. Momentum indicator: RSI
# RSI: Relative strength index
# Measures momentum of a trend
# range: 0-100
# >70: overbought, <30: oversold
# 1. Calculate the RSI
# Calculate RSI with the default time period
stock_data['RSI_14'] = talib.RSI(stock_data['Close'])

# Calculate RSI with a time period of 21
stock_data['RSI_21'] = talib.RSI(stock_data['Close'], timeperiod=21)

# Print the last five rows
print(stock_data.tail())

# 2. Visualize the RSI
# Calculate RSI
stock_data['RSI'] = talib.RSI(stock_data['Close'])

# Create subplots
fig, (ax1, ax2) = plt.subplots(2)
# Plot RSI with the price
ax1.set_ylabel('Price')
ax1.plot(stock_data['Close'])
ax2.set_ylabel('RSI')
ax2.plot(stock_data['RSI'], color='orangered')

ax1.set_title('Price and RSI')
plt.show()

# D. Volatility indicator: Bollinger Bands
# 1. Implement Bollinger Bands
# Define the Bollinger Bands with 2-sd
upper_2sd, mid_2sd, lower_2sd = talib.BBANDS(bitcoin_data['Close'],
                                     nbdevup=2,
                                     nbdevdn=2,
                                     timeperiod=20)
# Plot the upper and lower Bollinger Bands 
plt.plot(bitcoin_data['Close'], color='green', label='Price')
plt.plot(upper_2sd, color='orange', label='Upper 2sd')
plt.plot(lower_2sd, color='orange', label='Lower 2sd')

# Customize and show the plot
plt.legend(loc='upper left')
plt.title('Bollinger Bands (2sd)')
plt.show()
