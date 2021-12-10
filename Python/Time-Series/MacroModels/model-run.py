# Model build and estimation

# A. Initial setup
# Import packages and modules
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time
import sys
import os
import plotly.express as px
from sklearn.linear_model import LinearRegression
from sklearn import metrics
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.sandbox.regression.predstd import wls_prediction_std
from statsmodels.stats.outliers_influence import OLSInfluence
from statsmodels.compat import lzip
import statsmodels.formula.api as smf
import statsmodels.stats.api as sms
from statsmodels.graphics.regressionplots import plot_leverage_resid2

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

# Show all cell outputs requested
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"

# Warnings module. Print a warning message once.
import warnings
#warnings.simplefilter('once', category=UserWarning)
warnings.simplefilter('ignore', category=UserWarning)

# B. Dependent variable
# Import the dataset that was created using ODR Curve
df = pd.read_csv('odr.csv', index_col='month', parse_dates=True)
df.head()

# Visualisation with slider
fig = px.line(df, x=df.index, y='ODR', title='ODR with slider')
fig.update_xaxes(rangeslider_visible=True)
fig.show()

# Bring in the dependent variable transformation that is being used for this development
# CSV file = dep_var_new.csv, created in the notebook Dependent Variable
df_dep = pd.read_csv('dep_var_new.csv', index_col='month', parse_dates=True)
df_dep = df_dep.loc[:, 'ODR_X']
df_dep.head()

# C. Independent Variable
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

# D. All transformations
# Columns for review
df_ind.columns

# Apply the basic transformations method
df_ind1 = df_ind.copy()
stmd.transformations().basic_transformations(df_ind1, 1)
# Drop initial columns after transformation
orig_cols = list(df_ind.columns)
df_ind1.drop(columns=orig_cols, inplace=True)

# Add the lagged method to create range of transformed variables
df_ind2 = df_ind1.copy()
stmd.transformations().create_lags(df_ind2)
# Drop original columns from the final transformed list
orig_cols = list(df_ind1.columns)
df_ind2.drop(columns=orig_cols, inplace=True)

# Import the final independent variable list. Contains the variable with the transformation
df_final_ind = pd.read_excel('Final_Independent_Variables.xlsx',engine='openpyxl')
df_final_ind

# Create the list of independent variables
df_indep_list = [x for x in df_final_ind['VARIABLE']]
df_indep_list

# Datasets to use for estimation
dep = df_dep
indep = df_ind2[['var1','var2']]
indep

