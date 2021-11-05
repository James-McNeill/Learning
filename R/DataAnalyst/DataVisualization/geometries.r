# Working with the different geometries

# A. Scatter plots
# 1. Overplotting 1: large datasets
# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, aes(carat, price, color = clarity))

# Add a point layer with tiny points
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = ".")

# Set transparency to 0.5. Remove line outlines by adjusting shape
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = 16)

# 2. Overplotting 2: aligned values. Occurs when one axis is continuous and the other is categorical
# Plot base
plt_mpg_vs_fcyl_by_fam <- ggplot(mtcars, aes(fcyl, mpg, color = fam))

# Default points are shown for comparison
plt_mpg_vs_fcyl_by_fam + geom_point()

# Alter the point positions by jittering, width 0.3
plt_mpg_vs_fcyl_by_fam + geom_point(position = position_jitter(0.3))

# Now jitter and dodge the point positions
plt_mpg_vs_fcyl_by_fam + geom_point(position = position_jitterdodge(jitter.width = 0.3, dodge.width = 0.3))

# 3. Overplotting 3: Low-precision data. Measurements for data points were taken at low resolution level (e.g. mm)
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Swap for jitter layer with width 0.1
  geom_jitter(alpha = 0.5, width = 0.1)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Set the position to jitter
  geom_point(position = "jitter", alpha = 0.5)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Use a jitter position function with width 0.1
  geom_point(alpha = 0.5, position = position_jitter(width = 0.1))

# 4. Overplotting 4: Integer data
# Examine the structure of Vocab
str(Vocab)

# Plot vocabulary vs. education
ggplot(Vocab, aes(education, vocabulary)) +
  # Add a point layer
  geom_point()

# Add a jitter layer
ggplot(Vocab, aes(education, vocabulary)) +
  # Change to a jitter layer
  geom_jitter()

ggplot(Vocab, aes(education, vocabulary)) +
  # Set the shape to 1
  geom_jitter(alpha = 0.2, shape = 1)

# B. Histograms
# 1. Drawing histograms
ggplot(mtcars, aes(mpg)) +
  # Set the binwidth to 1
  geom_histogram(binwidth = 1)

# Map y to the internal variable ..density.. show frequency densities
ggplot(mtcars, aes(mpg, y = ..density..)) +
  geom_histogram(binwidth = 1)

# Change the fill color
datacamp_light_blue <- "#51A8C9"

ggplot(mtcars, aes(mpg, ..density..)) +
  # Set the fill color to datacamp_light_blue
  geom_histogram(binwidth = 1, fill = datacamp_light_blue)

# 2. Positions in histograms
ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to fill. Bars fill the y-axis
  geom_histogram(binwidth = 1, position = "fill")

ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to identity, with transparency 0.4
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4) 

# C. Bar plots
# Plot fcyl, filled by fam
ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Add a bar layer
  geom_bar()

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Set the position to "fill"
  geom_bar(position = "fill")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Change the position to "dodge"
  geom_bar(position = "dodge")

# 2. Overlapping bar plots
ggplot(mtcars, aes(cyl, fill = fam)) +
  # Change position to use the functional form, with width 0.2
  geom_bar(position = position_dodge(width = 0.2))

ggplot(mtcars, aes(cyl, fill = fam)) +
  # Set the transparency to 0.6
  geom_bar(position = position_dodge(width = 0.2), alpha = 0.6)

# 3. Sequential color palette
# Plot education, filled by vocabulary
ggplot(Vocab, aes(education, fill = vocabulary)) +
  # Add a bar layer with position "fill"
  geom_bar(position = "fill") +
  # Add a brewer fill scale with default palette
  scale_fill_brewer()

# D. Line plots
# 1. Basic Line plots
# Print the head of economics
head(economics)

# Using economics, plot unemploy vs. date
ggplot(economics, aes(date, unemploy)) +
  # Make it a line plot
  geom_line()

# Change the y-axis to the proportion of the population that is unemployed
ggplot(economics, aes(date, y = unemploy / pop)) +
  geom_line()

# 2. Multiple time series
# Plot the Rainbow Salmon time series
ggplot(fish.species, aes(x = Year, y = Rainbow)) +
  geom_line()

# Plot the Pink Salmon time series
ggplot(fish.species, aes(x = Year, y = Pink)) +
  geom_line()

# Plot multiple time-series by grouping by species
ggplot(fish.tidy, aes(Year, Capture)) +
  geom_line(aes(group = Species))

# Plot multiple time-series by coloring by species
ggplot(fish.tidy, aes(x = Year, y = Capture, color = Species)) +
  geom_line(aes(group = Species))
