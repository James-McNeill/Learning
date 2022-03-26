# Customizing Visualizations
# Customize axes, create and enhance a legend, modify glyph settings, and apply Bokeh's custom themes

# A. Adding Style
# 1. Colors, legend, and theme
# Import curdoc
from bokeh.io import curdoc

# Change theme to contrast
curdoc().theme = "contrast"
fig = figure(x_axis_label="Year Built", y_axis_label="Land Area (Meters Squared)")

# Add north circle glyphs
fig.circle(x=north["year_built"], y=north["land_area"], color="yellow", legend_label="North")

# Add south circle glyphs
fig.circle(x=south["year_built"], y=south["land_area"], color="red", legend_label="South")

output_file(filename="north_vs_south.html")
show(fig)

# 2. Customizing glyphs
# Three data subsets have been created
houses = melb.loc[melb["type"] == "h"]
units = melb.loc[melb["type"] == "u"]
townhouses = melb.loc[melb["type"] == "t"]

# Create figure
fig = figure(x_axis_label="Year Built", y_axis_label="Distance from CBD (km)")

# Add circle glyphs for houses
fig.circle(x=houses["year_built"], y=houses["distance"], legend_label="House", color="purple")

# Add square glyphs for units
fig.square(x=units["year_built"], y=units["distance"], legend_label="Unit", color="red")

# Add triangle glyphs for townhouses
fig.triangle(x=townhouses["year_built"], y=townhouses["distance"], legend_label="Townhouse", color="green")
output_file(filename="year_built_vs_distance_by_property_type.html")
show(fig)

# B. Customizing axes
# 1. Average building size
# Group by date and calculate average building size
prop_size = melb.groupby("date", as_index=False)["building_area"].mean()
source = ColumnDataSource(data=prop_size)

# Create the figure
fig = figure(x_axis_label="Date", y_axis_label="Building Size (Meters Squared)", x_axis_type="datetime")

# Add line glyphs
fig.line(x="date", y="building_area", source=source)

# Generate the HTML file
output_file(filename="property_size_by_date.html")
show(fig)

# 2. Sales over time
melb_sales = melb.groupby("date", as_index=False)["price"].sum()

# Import the second formatter
from bokeh.models import DatetimeTickFormatter, NumeralTickFormatter
fig = figure(x_axis_label="Date", y_axis_label="Sales")

# Add line glyphs
fig.line(x="date", y="price", source=source)

# Format the x-axis format
fig.xaxis[0].formatter = DatetimeTickFormatter(months="%b %Y")

# Format the y-axis format
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0a")

output_file(filename="melbourne_sales.html")
show(fig)

