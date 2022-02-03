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
