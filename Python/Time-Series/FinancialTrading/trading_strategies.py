# Trading strategies
# You’re now ready to construct signals and use them to build trading strategies. 
# You’ll get to know the two main styles of trading strategies: trend following and mean reversion. 
# Working with real-life stock data, you’ll gain hands-on experience in implementing and backtesting 
# these strategies and become more familiar with the concepts of strategy optimization and benchmarking.

# A. Trading signals
# 1. Build an SMA-based signal strategy
# Calculate the SMA
sma = price_data.rolling(20).mean()

# Define the strategy
bt_strategy = bt.Strategy('AboveSMA', 
                          [bt.algos.SelectWhere(price_data > sma),
                           bt.algos.WeighEqually(),
                           bt.algos.Rebalance()])

# Create the backtest and run it
bt_backtest = bt.Backtest(bt_strategy, price_data)
bt_result = bt.run(bt_backtest)
# Plot the backtest result
bt_result.plot(title='Backtest result')
plt.show()

# 2. Build an EMA-based signal strategy
# price_data: contains the closing price data points time series
# Calculate the EMA
ema['Close'] = talib.EMA(price_data['Close'], timeperiod=20)

# Define the strategy
bt_strategy = bt.Strategy('AboveEMA',
                          [bt.algos.SelectWhere(price_data > ema),
                           bt.algos.WeighEqually(),
                           bt.algos.Rebalance()])

# Create the backtest and run it
bt_backtest = bt.Backtest(bt_strategy, price_data)
bt_result = bt.run(bt_backtest)
# Plot the backtest result
bt_result.plot(title='Backtest result')
plt.show()

# B. Trend following strategies
# 1. Construct an EMA crossover signal
# Trend following stratgies believe that "the trend is your friend"
# When the shorter-term EMA, EMA_short, is larger than the longer-term EMA, EMA_long, you will enter 
# long positions in the market. Vice versa, when EMA_short is smaller than EMA_long, you will enter short positions.
# A 10-day EMA and 40-day EMA have been pre-calculated and saved in EMA_short and EMA_long
# Construct the signal
signal[EMA_short > EMA_long] = 1
signal[EMA_short < EMA_long] = -1

# Merge the data 
combined_df = bt.merge(signal, price_data, EMA_short, EMA_long)
combined_df.columns = ['signal', 'Price', 'EMA_short', 'EMA_long']
# Plot the signal, price and MAs
combined_df.plot(secondary_y=['signal'])
plt.show()

# 2. Build and backtest a trend-following strategy
# Define the strategy
bt_strategy = bt.Strategy('EMA_crossover', 
                          [bt.algos.WeighTarget(signal),
                           bt.algos.Rebalance()])

# Create the backtest and run it
bt_backtest = bt.Backtest(bt_strategy, price_data)
bt_result = bt.run(bt_backtest)

# Plot the backtest result
bt_result.plot(title='Backtest result')
plt.show()

