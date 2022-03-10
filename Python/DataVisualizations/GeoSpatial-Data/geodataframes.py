# Creating and joining GeoDataFrames

# A. GeoJSON and plotting with geopandas
# 1. Colormaps
# Set legend style
lgnd_kwds = {'title': 'School Districts',
               'loc': 'upper left', 'bbox_to_anchor': (1, 1.03), 'ncol': 1}

# Plot the school districts using the tab20 colormap (qualitative)
school_districts.plot(column = 'district', cmap = 'tab20', legend = True, legend_kwds = lgnd_kwds)
plt.xlabel('Latitude')
plt.ylabel('Longitude')
plt.title('Nashville School Districts')
plt.show();

# 2. Map Nashville neighborhoods
import geopandas as gpd
import matplotlib.pyplot as plt

# Read in the neighborhoods geojson file
neighborhoods = gpd.read_file(neighborhoods_path)

# Print the first few rows of neighborhoods
print(neighborhoods.head())

# Plot the neighborhoods, color according to name and use the Dark2 colormap
neighborhoods.plot(column = 'name', cmap = 'Dark2')

# Show the plot.
plt.show()

# B. Projections and coordinate reference systems
# 1. Changing coordinate reference systems
