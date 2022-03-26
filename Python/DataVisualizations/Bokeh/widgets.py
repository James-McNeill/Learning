# Introduction to widgets

# A. Introduction to widgets
# 1. Adding a Div
# Import modules
from bokeh.models import Div
from bokeh.layouts import layout
fig = figure(x_axis_label="Date", y_axis_label="Stock Price ($)")
fig.line(x="date", y="close", source=source, color="purple")
box = BoxAnnotation(bottom=amazon["close"].mean(), fill_color="green", fill_alpha=0.3)
fig.add_layout(box)
fig.xaxis[0].formatter = DatetimeTickFormatter(months="%b %Y")

# Create title
title = Div(text="Amazon stock prices vs. average price over the period")
output_file(filename="amazon_stocks.html")

# Display layout
show(layout([title], [fig]))

# 2. Modifying glyph size with a widget
# Import modules
from bokeh.layouts import layout
from bokeh.models import Spinner
labels = ["ABBV", "JNJ", "LLY", "MRK", "NFX"]
fig = figure(x_axis_label="Volume", y_axis_label="Stock Price ($)")
scatter = fig.circle(x="volume", y="close", source=source, legend_field="name", fill_color=factor_cmap("name", palette=Category10_5, factors=labels), fill_alpha=0.5)
title = Div(text="Pharmaceuticals Stock Performance")
fig.xaxis[0].formatter = NumeralTickFormatter(format="0a")

# Create spinner
spinner = Spinner(title="Glyph size", low=1, high=30, step=1, value=4, width=60)

# Set up the widget action
spinner.js_link("value", scatter.glyph, "size")
output_file(filename="pharma_stocks.html")

# Display the layout
show(layout([title], [spinner, fig]))

# B. Slider widgets
# 1. Automotive stock analysis
# Import RangeSlider
from bokeh.models import RangeSlider
fig = figure(x_axis_label="Stock Price ($)", y_axis_label="Market Cap")
fig.circle(x=ford["close"], y=ford["market_cap"], legend_label="Ford", fill_color="red", fill_alpha=0.5)
fig.circle(x=gm["close"], y=gm["market_cap"], legend_label="GM", fill_color="green", fill_alpha=0.5)
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0a")

# Create slider
slider = RangeSlider(title="Stock Price", start=10, end=47, value=(10, 47), step=1)

# Link to start of x-axis
slider.js_link("value", fig.x_range, "start", attr_selector=0)

# Link to end of x-axis
slider.js_link("value", fig.x_range, "end", attr_selector=1)
output_file(filename="Slider.html")
show(layout([slider], [fig]))

# 2. Tech stock performance over time
# Import widget
from bokeh.models import DateRangeSlider
earliest_date = stocks["date"].min()
latest_date = stocks["date"].max()
fig.line(apple["date"], apple["close"], color="green", legend_label="Apple")
fig.line(netflix["date"], netflix["close"], color="red", legend_label="Netflix")
fig.line(ibm["date"], ibm["close"], color="purple", legend_label="IBM")
fig.legend.location = "top_left"

# Create DateRangeSlider
slider = DateRangeSlider(title="Date", start=earliest_date, end=latest_date, 
                         value=("2014, 6, 2", "2018, 2, 7"), step=1)

# Link DateRangeSlider values to figure
slider.js_link("value", fig.x_range, "start", attr_selector=0)
slider.js_link("value", fig.x_range, "end", attr_selector=1)

# Create layout and display plot
output_file(filename="stock_price_over_time.html")
show(layout([slider], [fig])) # Puts the slider above the figure by using this order with layout

