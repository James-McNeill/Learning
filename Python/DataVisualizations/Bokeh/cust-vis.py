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
