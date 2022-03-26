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

# C. Subplots
# 1. Categorical column subplots
# The column stacking works well because the same x-axis values are being used
# Import column
from bokeh.layouts import column
regions = ["Eastern", "Southern", "Western", "Northern"]
building_size = figure(x_axis_label="Region", y_axis_label="Building Size (Meters Squared)", x_range=regions)
land_size = figure(x_axis_label="Region", y_axis_label="Land Size (Meters Squared)", x_range=regions)

# Add bar glyphs
building_size.vbar(x="region", top="building_area", source=source)
land_size.vbar(x="region", top="land_area", source=source)

# Generate HTML file and display the subplots
output_file(filename="my_first_column.html")
show(column(building_size, land_size)) # order that the plots will be shown

# 2. Size, location, and price
# The row stacking works well because the same y-axis values are being used
# Import row
from bokeh.layouts import row
building_size = figure(x_axis_label="Building Area (Meters Squared)", y_axis_label="Sales")
distance = figure(x_axis_label="Distance from CBD (km)", y_axis_label="Sales")

# Add circle glyphs
building_size.circle(x="building_area", y="price", source=source)
distance.circle(x="distance", y="price", source=source)

# Update the y-axis format for both figures
building_size.yaxis[0].formatter = NumeralTickFormatter(format="$0a")
distance.yaxis[0].formatter = NumeralTickFormatter(format="$0a")

# Display the subplots
output_file(filename="my_first_row.html")
show(row(building_size, distance))

# 3. Using gridplot
# Import gridplot
from bokeh.layouts import gridplot
plots = []

# Complete for loop to create plots
for region in ["Northern", "Western", "Southern", "Eastern"]:
  df = melb.loc[melb["region"] == region]
  source = ColumnDataSource(data=df)
  fig = figure(x_axis_label="Building Area (Meters Squared)", y_axis_label="Price")
  fig.circle(x="building_area", y="price", source=source, legend_label=region)
  fig.yaxis[0].formatter = NumeralTickFormatter(format="$0a")
  plots.append(fig)

# Display plot
output_file(filename="gridplot.html")
show(gridplot(plots, ncols=2))

# 4. Changing size
# Set up figures. Adjusting the height and width helps to fit the plots better
distance_vs_year = figure(x_axis_label="Year Built", y_axis_label="Distance from CBD (km)", height=300, width=400)
building_size_vs_year = figure(x_axis_label="Year Built", y_axis_label="Building Size (Meters Squared)", height=300, width=400)

# Add circle glyphs to distance_vs_year
distance_vs_year.circle(x="year_built", y="distance", source=source)

# Add circle glyphs to building_size_vs_year
building_size_vs_year.circle(x="year_built", y="building_area", source=source)

# Generate HTML file and display plot
output_file(filename="custom_size_plot")
show(row(distance_vs_year, building_size_vs_year))

# D. Visualizing categorical data
# 1. High to low prices by region
regions = melb.groupby("region", as_index=False)["price"].mean()
# Sort df by price in descending order
regions = regions.sort_values("price", ascending=False)

# Create figure
fig = figure(x_range=regions["region"], x_axis_label="Region", y_axis_label="Sales")

# Add bar glyphs
fig.vbar(x=regions["region"], top=regions["price"], width=0.9)

# Format the y-axis to numeric format
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0.0a")

output_file(filename="sorted_barplot.html")
show(fig)

# 2. Creating nested categories
melb["month"] = melb["date"].dt.month
quarters = {1: "Q1", 2:"Q1", 3:"Q1", 4:"Q2", 5:"Q2", 6:"Q2", 7:"Q3", 8:"Q3", 9:"Q3", 10:"Q4", 11:"Q4", 12:"Q4"}
melb["quarter"] = melb["month"].replace(quarters)
melb["month"] = melb["month"].replace({1:"January", 2:"February", 3:"March", 4:"April", 5:"May", 6:"June", 7:"July", 8:"August", 9:"September", 10:"October", 11:"November", 12:"December"})

# Create factors
factors = [("Q1", "January"), ("Q1", "February"), ("Q1", "March"), 
           ("Q2", "April"), ("Q2", "May"), ("Q2", "June"), 
           ("Q3", "July"), ("Q3", "August"), ("Q3", "September"), 
           ("Q4", "October"), ("Q4", "November"), ("Q4", "December")]

# Calculate total sales by month and quarter
grouped_melb = melb.groupby(["month", "quarter"], as_index=False)["price"].sum()
grouped_melb.sort_values("quarter", inplace=True)
print(grouped_melb.head())

# 3. Visualizing sales by period
# Import NumeralTickFormatter and FactorRange
from bokeh.models import NumeralTickFormatter, FactorRange

# Create figure
fig = figure(x_range=FactorRange(*factors), y_axis_label="Sales") # extract the values from the tuples

# Create bar glyphs
fig.vbar(x=factors, top=grouped_melb["price"], width=0.9)
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0.0a")

# Rotate the x-axis labels
fig.xaxis.major_label_orientation = 45

output_file(filename="sales_by_period.html")
show(fig)
