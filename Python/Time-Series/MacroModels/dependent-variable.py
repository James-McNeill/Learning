# Performing a review of the dependent variable
# Dependent variable stationarity testing

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

# Create the pandas cursor object
pandas_cursor = stmd.create_cursor()

# Seaborn style defaults
sns.set(rc={'figure.figsize':(30,12)})
sns.set_style("darkgrid")

# Import the dataset that was created in the ODR-curve.py
df = pd.read_csv('odr.csv', index_col='month', parse_dates=True)
df.head()

# Visualisation with slider
fig = px.line(df, x=df.index, y='ODR', title='ODR with slider')
fig.update_xaxes(rangeslider_visible=True)
fig.show()

# Decomposition of the time series into: Base level, Trend, Seasonality and Error
from statsmodels.tsa.seasonal import seasonal_decompose
from dateutil.parser import parse

# Additive decomposition
result_add = seasonal_decompose(df['ODR'], model='additive', extrapolate_trend='freq')
# Plot
result_add.plot().suptitle('Additive Decompose', fontsize=22);

# Extracting the component parts
df_out = pd.concat([result_add.observed, result_add.seasonal, result_add.trend, result_add.resid], axis=1)
df_out.columns = ['Actual_values', 'Seasonality', 'Trend', 'Residual']
df_out.head()
# df_out.to_csv('odr_decompose.csv')

# Retain the actual and trend values
df_out = df_out.loc[:,['Actual_values','Trend']]
df_out = df_out.rename(columns={'Actual_values':'ODR', 'Trend':'ODR_trend'})
df_out.head()

# B. All transformations
# Columns for review
df_out.columns

# Apply the basic_transformations module
df_out1 = df_out.copy()
stmd.transformations().basic_transformations(df_out1, 1)
df_out1.head()

# Add the lagged method to create range of transformed variables
df_out2 = df_out1.copy()
stmd.transformations().create_lags(df_out2)
df_out2.head()

# Warnings module. Print a warning message once.
import warnings
warnings.simplefilter('once', category=UserWarning)

# Apply the stationarity testing
df_stat = stmd.stationarity().stationarity_test(df_out2)
df_stat

# Review stationary results - highlight stationarity for both tests
df_stat.loc[(df_stat['kpss_stat']=='Stationary') & (df_stat['adf_stat']=='Stationary')]

# Review stationarity results for ADF only
df_stat.loc[(df_stat['adf_stat']=='Stationary')]

# Review stationarity results for kpss only
df_stat.loc[(df_stat['kpss_stat']=='Stationary')]

# Filters the missing values for the column selected. Keeps all other data points
df_final = df_out1.loc[df_out1['ODR_Q'].notnull(), ['ODR_Q', 'ODR_X', 'ODR_Z', 'ODR_trend_X']]
# Limits the display to one column
# df_final.to_csv('dep_var_new.csv')
df_final.head()

# Final curves reviewed together
fig = px.line(df_final, x=df_final.index, y=df_final.columns, title='ODR with slider')
fig.update_xaxes(rangeslider_visible=True)
fig.show()
