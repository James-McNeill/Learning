# Creating the ODR curve by various feature segments
# Aim is to perform t-test's to compare the variance of the segment curves

# Create connection to AWS Athena
# Import utilities, PyAthena and other modules
import pandas as pd
import numpy as np
import datetime
import time
import sys
import os
from pathlib import Path

# Print current working directory location
print(os.getcwd()+'/')
# Connect to the repo package folder to use in this Notebook
sys.path.append("/home/ec2-user/SageMaker/s3-user-bucket/..../")
# Import the sub-packages
from stmd import utils as stmd

# Set default options for the notebook
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.options.display.float_format = '{:,.4f}'.format # Comma and four decimal places for float variables

# Create the pandas cursor object
pandas_cursor = stmd.create_cursor()

# B. Input data creation
# Running the build dod model dataset extraction only
dod = stmd.build_dod().build_dod_model()
dod.head()

# Running the build dod model dataset and including the additional datasets for 2020.
df = stmd.build_dod().build_dod_all('DATABASE', 'INPUT_TABLE_')
df.head()

# Create the default n12m column
# Each of the methods that are mentioned above are combined into the method default_n12m_all. This
# method is used to create the default flow and perform the operations required to develop the 
# variable "def_n12m"
df = stmd.build_dod().default_n12m_all(df)
df.loc[(df['account_no'] == 000000000)].head(20) # example account to show how the dataset has been created

# Bring in the model segments
# Extract the dataframe from AWS Athena
df_mort = pandas_cursor.execute(
    """
    SELECT account_no, 
        month,
        btl_flag,
        index_ltv,
        orig_term_of_loan
    FROM DATABASE.MONTH_STACK
    """
    , keep_default_na=True
    , na_values=[""]
).as_pandas()

# Convert some of the variable data types
convert_dict = {'account_no': 'int64'}
df_mort = df_mort.astype(convert_dict)
# Sort the order of the loans by unique reference and time stamp
df_mort = df_mort.sort_values(by=['account_no','month'], ignore_index=True)

df_mort.head()

# Merge the segment data to the overall ODR dataset
df = pd.merge(df, df_mort, how='left', on=['account_no', 'month'])
df.head()

# Create the variables to use for segmentation
# df.isnull().sum()
df['btl_flag'] = np.where(df['btl_flag'].isnull(), 'N', df['btl_flag'])
df['index_ltv_band'] = np.where(df['index_ltv'] <= 80, "LE80", "GT80")
df['orig_term_band'] = np.where(df['orig_term_of_loan'] <= 300, "LE300", "GT300")

# C. Create the ODR curve
# Input dataset. Only keep reporting months with 12 months of data in the future
df.month.max()
date_filt = np.array(df.month <= '2019-12-01')
df1 = df.copy()
df1 = df1.loc[(date_filt)]
df1.month.max()

# Create the variables used within the ODR calculation. Method allows for the 
# aggregation of the two key variables within the ODR calculation (# perf and # default flow n12m)
def summary(x):
    result = {
                'perf': (np.where(x['DEFAULT']==0,1,0)).sum()
                ,'def': (np.where((x['DEFAULT']==0) & (x['def_n12m']==1),1,0)).sum()
            }
    return pd.Series(result).round(4)

# Visualise the output
def dep_seg_line(df, variable):
    df_s = df.groupby(['month', variable]).apply(summary)
    df_s['ODR'] = df_s['def'] / df_s['perf']
    df_s = df_s.reset_index()
    fig = px.line(df_s, x='month', y='ODR', color=variable, title='ODR with segmentation')
    fig.update_xaxes(rangeslider_visible=True)
    return fig.show()

dep_seg_line(df1, 'btl_flag')
dep_seg_line(df1, 'index_ltv_band')
dep_seg_line(df1, 'orig_term_band')

# Method to review the segmentation and produce t-test results
def t_test(df, variable):
    df_s = df.groupby(['month', variable]).apply(summary)
    df_s['ODR'] = df_s['def'] / df_s['perf']
    df_s = df_s.reset_index()
    group1 = df_s.loc[(df_s[variable] == df_s[variable].unique()[0]), ['ODR']]
    group2 = df_s.loc[(df_s[variable] == df_s[variable].unique()[1]), ['ODR']]
    out = stats.ttest_ind(group1, group2, equal_var = False)
    return out

# Produce the t-test statistics
t_test(df1, 'btl_flag')
t_test(df1, 'index_ltv_band')
t_test(df1, 'orig_term_band')
