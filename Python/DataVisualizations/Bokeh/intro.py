# Introduction to Bokeh

# A. Introduction to Bokeh
# 1. NBA data: Blocks vs. rebounds
# Import required libraries
from bokeh.plotting import figure
from bokeh.io import output_file, show

# Create a new figure
fig = figure(x_axis_label="Blocks per Game", y_axis_label="Rebounds per Game")

# Add circle glyphs
fig.circle(x=nba["blocks"], y=nba["rebounds"])

# Call function to produce html file and display plot
output_file(filename="my_first_plot.html")
show(fig)

# 2. Kevin Durants performance across seasons
# Create figure
fig = figure(x_axis_label="Season", y_axis_label="Points")

# Add line glyphs
fig.line(x=kevin_durant["season"], y=kevin_durant["points"])

# Generate HTML file
output_file(filename="Kevin_Durant_performance.html")

# Display plot
show(fig)

# 3. Shooting ability by position
# Calculate average three point field goal percentage by position
positions = nba.groupby("position", as_index=False)["three_point_perc"].mean()

# Instantiate figure
fig = figure(x_axis_label="Position", y_axis_label="3 Point Field Goal (%)", x_range=positions["position"]) 

# Add bars
fig.vbar(x=positions["position"], top=positions["three_point_perc"])

# Produce the html file and display the plot
output_file(filename="3p_fg_by_position.html")
show(fig)
