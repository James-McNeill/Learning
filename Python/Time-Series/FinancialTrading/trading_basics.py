# Introduction to trading concepts

# A. What is financial trading
# 1. Plot a time series line chart
# Load the data
bitcoin_data = pd.read_csv('bitcoin_data.csv', index_col='Date', parse_dates=True)

# Print the top 5 rows
print(bitcoin_data.head())

# Plot the daily high price
plt.plot(bitcoin_data['High'], color='green')
# Plot the daily low price
plt.plot(bitcoin_data['Low'], color='red')

plt.title('Daily high low prices')
plt.show()

# 2. Plot a candlestick chart
import plotly.graph_objects as go

# Define the candlestick data
candlestick = go.Candlestick(
    x=bitcoin_data.index,
    open=bitcoin_data['Open'],
    high=bitcoin_data['High'],
    low=bitcoin_data['Low'],
    close=bitcoin_data['Close'])

# Create a candlestick figure   
fig = go.Figure(data=[candlestick])
fig.update_layout(title='Bitcoin prices')                        

# Show the plot
fig.show()

# B. Getting familiar with your trading data
# 1. Resample the data
# Switch the sample from a day trader (hourly, time periods) to a swing trader (daily) and then a position trader (weekly), and manipulate the data to suit your needs
# Resample the data to daily by calculating the mean values
eurusd_daily = eurusd_4h.resample('d').mean()

# Print the top 5 rows
print(eurusd_daily.head())

# Resample the data to weekly by calculating the mean values
eurusd_weekly = eurusd_4h.resample('w').mean()

# Print the top 5 rows
print(eurusd_weekly.head())

# 2. Plot a return histogram
# Calculate daily returns
tsla_data['daily_return'] = tsla_data['Close'].pct_change() * 100

# Plot the histogram
tsla_data['daily_return'].hist(bins=100, color='red')
plt.ylabel('Frequency')
plt.xlabel('Daily return')
plt.title('Daily return histogram')
plt.show()

# 3. Calculate and plot Simple Moving Averages (SMAs)
# Calculate SMA
aapl_data['sma_50'] = aapl_data['Close'].rolling(50).mean()

# Plot the SMA
plt.plot(aapl_data['sma_50'], color='green', label='SMA_50')
# Plot the close price
plt.plot(aapl_data['Close'], color='red', label='Close')

# Customize and show the plot
plt.title('Simple moving averages')
plt.legend()
plt.show()

# C. Financial trading with bt
# 1. Define and backtest a simple strategy
# The bt package
# A flexible framework for defining and backtesting trading strategies. The strategy related to trading the FAANG companies over a six month period
# Define the strategy
bt_strategy = bt.Strategy('Trade_Weekly', 
                         [bt.algos.RunWeekly(),
                          bt.algos.SelectAll(),
                          bt.algos.WeighEqually(),
                          bt.algos.Rebalance()])
# Create a backtest
bt_test = bt.Backtest(bt_strategy, bt_data)

# Run the backtest
bt_res = bt.run(bt_test)

# Plot the test result
bt_res.plot(title="Backtest result")
plt.show()
