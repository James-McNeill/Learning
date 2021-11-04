# Visualising the aesthetics

# A. Visible aesthetics
# 1. Color, shape and size attributes
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Set the shape and size of the points
  geom_point(shape = 1, size = 4)

# 2. Color Vs Fill attributes
# shape: different shape values can be displayed. Value 21 allows a circle to be colored with a fill and outline
# fill: color the inside
# color: color the outline
# Map color to fam
ggplot(mtcars, aes(wt, mpg, fill = fcyl, color = fam)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)

# 3. Comparing aesthetics
# Establish the base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Map fcyl to size
plt_mpg_vs_wt +
  geom_point(aes(size = fcyl))

# Map fcyl to alpha, not size
plt_mpg_vs_wt +
  geom_point(aes(alpha = fcyl))

# Map fcyl to shape, not alpha
plt_mpg_vs_wt +
  geom_point(aes(shape = fcyl))

# Use text layer and map fcyl to label
plt_mpg_vs_wt +
  geom_point(aes(shape = fcyl)) +
  geom_text(aes(label = fcyl))

# B. Attributes
# 1. Color, shape, size and alpha
# A hexadecimal color
my_blue <- "#4ABEFF"

ggplot(mtcars, aes(wt, mpg)) +
  # Set the point color and alpha
  geom_point(color = my_blue, alpha = 0.6)

# Change the color mapping to a fill mapping
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  # Set point size and shape
  geom_point(color = my_blue, size = 10, shape = 1)

# 2. Conflicts with aesthetics
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add point layer with alpha 0.5
  geom_point(alpha = 0.5)

ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add text layer with label rownames(mtcars) and color red
  geom_text(label = rownames(mtcars), color = "red")

ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add points layer with shape 24 and color yellow
  geom_point(shape = 24, color = "yellow")

# 3. Going all out
# 5 aesthetics
ggplot(mtcars, aes(mpg, qsec, color = fcyl, shape = fam, size = hp / wt)) +
  geom_point()

# C. Modifying aesthetics
# 1. Updating aesthetics labels
ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  # Set the axis labels
  labs(x = "Number of Cylinders", y = "Count")

# Using the scale_fill_manual
palette <- c(automatic = "#377EB8", manual = "#E41A1C")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  labs(x = "Number of Cylinders", y = "Count") +
  # Set the fill color scale
  scale_fill_manual("Transmission", values = palette)

# Adding a position parameter
palette <- c(automatic = "#377EB8", manual = "#E41A1C")

# Set the position so that the bars are side by side
ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar(position = "dodge") +
  labs(x = "Number of Cylinders", y = "Count")
  scale_fill_manual("Transmission", values = palette)

# 2. Setting a dummy aesthetic. Can setup limits on plots
# Plot 0 vs. mpg
ggplot(mtcars, aes(mpg, 0)) +
  # Add jitter 
  geom_point(position = "jitter")

# define the y limits range
ggplot(mtcars, aes(mpg, 0)) +
  geom_jitter() +
  # Set the y-axis limits
  ylim(-2, 2)
