# Location Analysis
# Working with the module Folium
# Sample dataset: ie_towns_sample.csv

# Dataset location: https://www.irelandtownslist.com/

# The dataset provides a sample of the towns within Ireland beginning with the letter A. 
# With a sample of locations the latitude and longitude can be used to highlight the methods available within the Folium module.

# Additional analysis
# Aim to bring in the planning applications data: https://data.gov.ie/dataset/irishplanningapplications

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

