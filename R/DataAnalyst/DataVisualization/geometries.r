# Working with the different geometries

# A. Scatter plots
# 1. Overplotting 1: large datasets
# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, aes(carat, price, color = clarity))

# Add a point layer with tiny points
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = ".")

# Set transparency to 0.5. Remove line outlines by adjusting shape
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = 16)
