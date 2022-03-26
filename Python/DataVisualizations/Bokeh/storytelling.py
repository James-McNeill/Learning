# Storytelling with Visualizations
# Learn how to use various elements to communicate with stakeholders.

# A. Customizing glyph settings
# 1. Shooting guards vs. small forwards
TOOLTIPS = [("Name", "@player"), ("Team", "@team"), ("Field Goal %", "@field_goal_perc{0.2f}")]
fig = figure(x_axis_label="Assists", y_axis_label="Points", title="Shooting Guard vs Small Forward", tooltips=TOOLTIPS)

# Add glyphs for shooting guards. size: change pixel size, fill_alpha: adjust transparency
fig.circle(x="assists", y="points", source=shooting_guards, legend_label="Shooting Guard", size=16, fill_color="red", fill_alpha=0.2)

# Add glyphs for small forwards
fig.circle(x="assists", y="points", source=small_forwards, legend_label="Small Forward", size=6, fill_color="green", fill_alpha=0.6)

output_file(filename="sg_vs_sf.html")
show(fig)

# 2. Big shooters
fig = figure(x_axis_label="Field Goal Percentage", y_axis_label="Three Point Field Goal Percentage", tooltips = TOOLTIPS)
center_glyphs = fig.circle(x="field_goal_perc", y="three_point_perc", source=centers, legend_label="Center", fill_alpha=0.2)
power_forward_glyphs = fig.circle(x="field_goal_perc", y="three_point_perc", source=power_forwards, legend_label="Power Forward", fill_color="green", fill_alpha=0.6)

# Update glyph size after the figure has been created
center_glyphs.glyph.size = 20
power_forward_glyphs.glyph.size = 10

# Update glyph fill_color
center_glyphs.glyph.fill_color = "red"
power_forward_glyphs.glyph.fill_color = "yellow"
output_file(filename="big_shooters.html")
show(fig)

# 3. Evolution of the point guard
fig = figure(x_axis_label="Season", y_axis_label="Performance")

# Add line glyphs for Steph Curry
fig.line(x="season", y="points", source=steph, line_width=2, line_color="green", alpha=0.5, legend_label="Steph Curry Points")
fig.line(x="season", y="assists", source=steph, line_width=4, line_color="purple", alpha=0.3, legend_label="Steph Curry Assists")

# Add line glyphs for Chris Paul
fig.line(x="season", y="points", source=chris, line_width=1, line_color="red", alpha=0.8, legend_label="Chris Paul Points")
fig.line(x="season", y="assists", source=chris, line_width=3, line_color="orange", alpha=0.2, legend_label="Chris Paul Assists")

output_file(filename="point_guards.html")
show(fig)

# B. Highlighting and contrasting
# 1. Highlighting by glyph size
# Create sizes
east_sizes = east["blocks"] / 5
west_sizes = west["blocks"] / 5
fig = figure(x_axis_label="Assists", y_axis_label="Points", title="NBA Points, Blocks, and Assists by Conference")

# Add circle glyphs for east
fig.circle(x=east["assists"], y=east["points"], fill_color="blue", fill_alpha=0.3, legend_label="East", radius=east_sizes)

# Add circle glyphs for west
fig.circle(x=west["assists"], y=west["points"], fill_color="red", fill_alpha=0.3, legend_label="West", radius=west_sizes)

output_file(filename="size_contrast.html")
show(fig)

# 2. Steals vs. Assists
# Import required modules
from bokeh.palettes import RdBu8
from bokeh.transform import linear_cmap

# Create mapper
mapper = linear_cmap(field_name="assists", palette=RdBu8, low=min(nba["assists"]), high=max(nba["assists"]))

# Create the figure
fig = figure(x_axis_label="Steals", y_axis_label="Assists", title="Steals vs. Assists")

# Add circle glyphs
fig.circle(x="steals", y="assists", source=source, color=mapper)
output_file(filename="steals_vs_assists.html")
show(fig)

# 3. Adding a color bar
# Import ColorBar
from bokeh.models import ColorBar

mapper = linear_cmap(field_name="assists", palette=RdBu8, low=min(nba["assists"]), high=max(nba["assists"]))
fig = figure(x_axis_label="Steals", y_axis_label="Assists", title="Steals vs. Assists")
fig.circle(x="steals", y="assists", source=source, color=mapper)

# Create the color_bar
color_bar = ColorBar(color_mapper=mapper["transform"], width=8)

# Update layout with color_bar on the right
fig.add_layout(color_bar, "right")
output_file(filename="steals_vs_assists_color_mapped.html")
show(fig)

# 4. Free throw percentage by position
# Import modules
from bokeh.transform import factor_cmap
from bokeh.palettes import Category10_5

# Create positions
positions = ["PG", "SG", "SF", "PF", "C"]
fig = figure(x_axis_label="Free Throw Percentage", y_axis_label="Points", title="Free Throw Percentage vs. Average Points", tooltips=TOOLTIPS)

# Add circle glyphs
fig.circle(x="free_throw_perc", y="points", source=source, legend_field="position", fill_color=factor_cmap("position", palette=Category10_5, factors=positions))

output_file(filename="average_points_vs_free_throw_percentage.html")
show(fig)

# C. Communicating with text
# 1. Sales by time and type of day
# Create figure
fig = figure(x_range=FactorRange(*factors), y_axis_label="Sales", title="Sales by type of day")

# Create bar glyphs
fig.vbar(x=factors, top=grouped_bakery["sales"], width=0.9)
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0,0")

# Update title text size
fig.title.text_font_size = "25px"

# Update title alignment
fig.title.align = "center"

output_file("sales_by_type_of_day.html")
show(fig)

# 2. Products sold by the time of day
fig = figure(x_axis_label="Count of Products Sold", y_axis_label="Sales", title="Bakery Product Sales", tooltips=TOOLTIPS)
fig.circle(x="count", y="sales", source=morning, line_color="red", size=12, fill_alpha=0.4, legend_label="Morning")
fig.circle(x="count", y="sales", source=afternoon, fill_color="purple", size=10, fill_alpha=0.6, legend_label="Afternoon")
fig.circle(x="count", y="sales", source=evening, fill_color="yellow", size=8, fill_alpha=0.6, legend_label="Evening")

# Add legend title
fig.legend.title = "Time of Day"

# Move the legend
fig.legend.location = "top_left"

# Make the legend interactive
fig.legend.click_policy = "hide"
fig.yaxis[0].formatter = NumeralTickFormatter(format="$0.00")
output_file("Sales_by_time_of_day")
show(fig)
