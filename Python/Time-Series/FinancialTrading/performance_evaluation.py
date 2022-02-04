# Performance Evaluation
# How is your trading strategy performing? Now it’s time to take a look at the detailed statistics of the strategy backtest result. 
# You’ll gain knowledge of useful performance metrics, such as returns, drawdowns, Calmar ratio, Sharpe ratio, and Sortino ratio. 
# You’ll then tie it all together by learning how to obtain these ratios from the backtest results and evaluate the strategy performance on a risk-adjusted basis

# A. Strategy return analysis
# 1. Review return results of a backtest
# Obtain all backtest stats
resInfo = bt_result.stats

# Get daily, monthly, and yearly returns
print('Daily return: %.4f'% resInfo.loc['daily_mean'])
print('Monthly return: %.4f'% resInfo.loc['monthly_mean'])
print('Yearly return: %.4f'% resInfo.loc['yearly_mean'])

# Get the compound annual growth rate
print('Compound annual growth rate: %.4f'% resInfo.loc['cagr'])

# 2. Plot return histograms of a backtest
# Plot the daily return histogram
bt_result.plot_histograms(bins=50, freq='d')
plt.show()

# Plot the weekly return histogram
bt_result.plot_histograms(bins=50, freq='w')
plt.show()

# 3. Compare return results of multiple strategies
# Plot the backtest result
bt_results.plot(title='Backtest result')
plt.show()

# Get the lookback returns
lookback_returns = bt_results.display_lookback_returns()
print(lookback_returns)

# B. Drawdown
# Reviews the difference between peak and trough values
# 1. Review performance with drawdowns
# Obtain all backtest stats
resInfo = bt_result.stats

# Get the average drawdown
avg_drawdown = resInfo.loc['avg_drawdown']
print('Average drawdown: %.2f'% avg_drawdown)

# Get the average drawdown days
avg_drawdown_days = resInfo.loc['avg_drawdown_days']
print('Average drawdown days: %.0f'% avg_drawdown_days)

# 2. Calculate and review the Calmar ratio
# Calmar ratio performs a risk adjusted review. A value >= 3 is viewed as good
# Get the CAGR
cagr = resInfo.loc['cagr']
print('Compound annual growth rate: %.4f'% cagr)

# Get the max drawdown
max_drawdown = resInfo.loc['max_drawdown']
print('Maximum drawdown: %.2f'% max_drawdown)

# Calculate Calmar ratio manually
calmar_calc = cagr / max_drawdown * (-1)
print('Calmar Ratio calculated: %.2f'% calmar_calc)

# Get the Calmar ratio
calmar = resInfo.loc['calmar']
print('Calmar Ratio: %.2f'% calmar)

# C. Sharpe and sortino ratios
# 1. Evaluate strategy performance Sharpe Ratio
# Get annual return and volatility
yearly_return = resInfo.loc['yearly_mean']
print('Annual return: %.2f'% yearly_return)
yearly_vol = resInfo.loc['yearly_vol']
print('Annual volatility: %.2f'% yearly_vol)

# Calculate the Sharpe ratio manually
sharpe_ratio = yearly_return / yearly_vol
print('Sharpe ratio calculated: %.2f'% sharpe_ratio)

# Print the Sharpe ratio
print('Sharpe ratio %.2f'% resInfo.loc['yearly_sharpe'])

# 2. Sortino Ratio
yearly_sortino = resInfo.loc['yearly_sortino']
monthly_sortino = resInfo.loc['monthly_sortino']
