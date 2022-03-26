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
