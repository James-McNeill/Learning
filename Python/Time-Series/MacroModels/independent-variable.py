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

# Display the indepdent variables to understand them visually across the time series
fig = px.line(df_ind, facet_col='macro', facet_col_wrap=2,
             facet_row_spacing=0.04,
             facet_col_spacing=0.04,
             height=600, width=800)
#fig.update_yaxes(range=[-1,500])
fig.show()

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

# Apply the missing_infinity_values method
df_miss_inf = stmd.transformations().missing_infinity_values(df_ind2)
df_miss_inf

# Need to understand the summary stats for the missing and infinity values
df_miss_inf['MissingVals'].value_counts()
df_miss_inf['InfinityVals'].value_counts()

# Exclude any columns with infinity values present and keep only missing values < 60
exclude = np.logical_and(df_miss_inf['InfinityVals'] == 0, 
                         df_miss_inf['MissingVals'] < 60)
df_miss_inf = df_miss_inf[exclude]
df_miss_inf

# Create final list of independent variables for stationarity analysis
df_ind_cols = list(df_miss_inf['Column'])
print(len(df_ind_cols))
df_ind3 = df_ind2[df_ind_cols]
df_ind3

# E. Stationarity testing
# Independent variable stationarity testing
df_stat_ind = stmd.stationarity().stationarity_test(df_ind3)
df_stat_ind

# Check the stationary variables for review
df_stat_ind1 = df_stat_ind.loc[(df_stat_ind['adf_stat']=='Stationary') | (df_stat_ind['kpss_stat']=='Stationary')]
df_stat_ind1

# List of independent variables to review
df_indep_list = [x for x in df_stat_ind['variable']]
print(len(df_indep_list))
df_indep_list

# F. Correlation analysis
# Run the correlation analysis
df_ind_ = df_ind3[df_indep_list]
df_dep_ = df_dep.loc[:,['ODR_X']]
dep = 'ODR_X'

# Run the Correlation class to create the correlation of independent variables with the dependent variable
df_corr = stmd.Correlation(df_ind_, df_dep_, dep).main()
df_corr

# Display output as a heatmap to outline the differences in correlation magnitude
sns.heatmap(df_corr, annot=True);

# Adjust the input data time window on the dependent variable to understand the potential impact on variables
time_window = np.array(df_dep.index >= '2009-09-01')
df_dep_1 = df_dep.loc[(time_window),['ODR_X']]
dep = 'ODR_X'
df_corr = stmd.Correlation(df_ind_, df_dep_1, dep).main()
df_corr

# G. R-Squared analysis
# Independent variable list
df_indep_list = [x for x in df_stat_ind['variable']]
df_ind_n = df_ind3[df_indep_list]

# Run the SingleFactor class - all data points in the time series
df_sfa = stmd.SingleFactor(df_ind_n, df_indep_list, df_dep, dep).main()
df_sfa

# Adjust the start date for the time series
df_sfa1 = stmd.SingleFactor(df_ind_n, df_indep_list, df_dep, dep, st_date='2009-06-01').main()
df_sfa1.head(15)
