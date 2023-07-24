#Future work
# - https://realpython.com/python-folium-web-maps-from-data/
# - take the multi colour mapping from the other location mapping notebook on Physical risks
# Cleared all outputs to save version of notebook. Including the mapping feature results in a much larger file as townlands is quite big.

# Location Analysis
# Working with the module Folium

# Sample dataset: townlands.csv
# Dataset location: https://www.townlands.ie/page/download/

# In order to see the map visualization, have to run the analysis using Jupyter Notebook

# Import modules
import pandas as pd
import numpy as np
import matplotlib.pyplot
import seaborn as sns
import time
import sys
import os
import pyarrow
import subprocess

# Importing libraries that are not currently installed within environment
def installPackage(package):
    p = subprocess.run([sys.executable, "-m", "pip", "install", "-U", package], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print(p.stdout.decode())

# Running the function to add missing library
requirements = ["folium"]
for requirement in requirements:
    installPackage(requirement)

# Bring in the additional libraries
import folium

# Bring in the Irish towns dataset
df = pd.read_csv('townlands.csv')

# Review the variable "T_IE_URL" to split out. Aiming to extract county value
def substring_after(s, delim):
    return s.partition(delim)[2]

# Split the string to understand the component parts and then extract the county variable
df['url_split'] = df.T_IE_URL.str.split("/")
df['str_after'] = df.T_IE_URL.apply(lambda x: substring_after(x, 'townlands.ie/'))
df['county'] = df.T_IE_URL.str.split("/").apply(lambda x: x[3])
df.loc[:, ["T_IE_URL", "str_after", "url_split", "county"]].head()

# Clustering the data
from folium.plugins import MarkerCluster

# Starting datapoint locations
Lat = 53.349921
Long = -6.260265

# Created a zipped list of the location data points
locations = list(zip(df.LATITUDE, df.LONGITUDE))

# Create the intial map template
map1 = folium.Map(location=[Lat,Long], zoom_start=10)

# Add the data clusters to the map that was created
markerCluster = MarkerCluster(data=locations).add_to(map1)

# Provide data point details for each location
for p in range(0, len(locations)):
    #folium.Marker(locations[p], popup=df['name'][p]).add_to(markerCluster)
    folium.Marker(locations[p] 
                  ,popup=df['NAME_TAG'][p]+',\n'+df['county'][p]
                 ).add_to(markerCluster)

# Display the map
map1

# Alternative approach if we wanted to add some colour to the popups based on a boolean filter
for p in range(0, len(locations)):
    if df['county'][p] == 'dublin':
        folium.Marker(locations[p] 
                      ,popup=df['NAME_TAG'][p]
                      ,icon=folium.Icon(color="green")
                     ).add_to(markerCluster)
    else:
        folium.Marker(locations[p] 
                  ,popup=df['NAME_TAG'][p]
                  ,icon=folium.Icon(color="red")
                 ).add_to(markerCluster)
map1
