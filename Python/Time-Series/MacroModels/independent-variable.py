# Working with the independent variables
# Performing stationarity, correlation and single factor analysis

# A. Initial setup
# Create connection to AWS Athena
# Import utilities, PyAthena and other modules
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time
import sys
import os
import plotly.express as px

# Print current working directory location
print(os.getcwd()+'/')
# Connect to the repo package folder to use in this Notebook
sys.path.append("/home/ec2-user/SageMaker/s3-user-bucket/.../")
# Import the sub-packages
from stmd import utils as stmd

# Formatting for the float variables
pd.options.display.float_format = '{:,.5f}'.format

# Seaborn style defaults
sns.set(rc={'figure.figsize':(30,12)})
sns.set_style("darkgrid")

# Show all cell outputs requested
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"

# Warnings module. Print a warning message once.
import warnings
#warnings.simplefilter('once', category=UserWarning)
warnings.simplefilter('ignore', category=UserWarning)

# B. Dependent variable
# Import the dataset that was created using the ODR curve
df = pd.read_csv('odr.csv', index_col='month', parse_dates=True)
df.head()

# Visualisation with slider
fig = px.line(df, x=df.index, y='ODR', title='ODR with slider')
fig.update_xaxes(rangeslider_visible=True)
fig.show()

# Bring in the dependent variable transformation that is being used for this development
# CSV file = dep_var.csv, created in the notebook Dependent Variable
df_dep = pd.read_csv('dep_var.csv', index_col='month', parse_dates=True)
df_dep.head()

# C. Independent variable
# Working with an excel file that contains multiple macro-economic variables across an historic time series
# Import the independent variable excel file
df_ind = pd.read_excel('INDEPENDENT_VARIABLES.xlsx',engine='openpyxl', index_col='Date', parse_dates=True).rename_axis('macro', axis=1)
# Adjust the month end dates to month begin dates. Allows for joining dataframes
df_ind.index = df_ind.index - pd.offsets.MonthBegin()
df_ind.head()

# Only need to keep the date values that relate to the dependent variable dataset
date_filt = np.array(df_ind.index <= '2019-12-01')
df_ind.index.max()
df_ind = df_ind[date_filt]
df_ind.index.max()
