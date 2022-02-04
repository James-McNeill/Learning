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

