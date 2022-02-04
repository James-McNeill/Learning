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

