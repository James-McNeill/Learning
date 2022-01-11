# Location Analysis
# Working with the module Folium

# Sample dataset: ie_towns_sample.csv
# Dataset location: https://www.irelandtownslist.com/

# The dataset provides a sample of the towns within Ireland beginning with the letter A. 
# With a sample of locations the latitude and longitude can be used to highlight the methods available within the Folium module.

# Additional analysis
# Aim to bring in the planning applications data: https://data.gov.ie/dataset/irishplanningapplications

# In order to see the map visualization, have to run the analysis using Jupyter Notebook

# Import modules
import pandas as pd
import numpy as np
import matplotlib.pyplot
import seaborn as sns
import time
import sys

# check and Install pyathena package.
# check_and_install_python_mod("geopandas")
# check_and_install_python_mod("folium")

# Bring in the additional libraries
import geopandas as gpd
import folium

# Bring in the Irish towns dataset
df = pd.read_csv('ie_towns_sample.csv')
df.head()

# Review the columns within the DataFrame
df.columns

# Clustering the data
from folium.plugins import MarkerCluster

# Starting datapoint locations
Lat = 53.349921
Long = -6.260265

# Created a zipped list of the location data points
locations = list(zip(df.latitude, df.longitude))

# Create the intial map template
map1 = folium.Map(location=[Lat,Long], zoom_start=10)

# Add the data clusters to the map that was created
markerCluster = MarkerCluster(data=locations).add_to(map1)

# Provide data point details for each location
for p in range(0, len(locations)):
    #folium.Marker(locations[p], popup=df['name'][p]).add_to(markerCluster)
    folium.Marker(locations[p] 
                  ,popup=df['name'][p]+',\n'+df['postal_town'][p]
                  +',\n'+df['county'][p]+',\n'+df['nuts3_region'][p]
                 ).add_to(markerCluster)

# Display the map
map1

# Alternative approach if we wanted to add some colour to the popups based on a boolean filter
for p in range(0, len(locations)):
    if df['Filter'][p] == 'Open':
        folium.Marker(locations[p] 
                      ,popup=df['name'][p]
                      ,icon=folium.Icon(color="green")
                     ).add_to(markerCluster)
    else:
        folium.Marker(locations[p] 
                  ,popup=df['name'][p]
                  ,icon=folium.Icon(color="red")
                 ).add_to(markerCluster)
map1
