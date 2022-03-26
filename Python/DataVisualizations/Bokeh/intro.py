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
