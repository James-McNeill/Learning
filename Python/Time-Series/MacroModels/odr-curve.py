# Developing an ODR curve

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

# After importing the combined default dataset, the default rules can be applied to create the 
# binary def_flow variable highlighting when loans enter default.

# Code retained to highlight how the method can be applied
# df = stmd.build_dod().default_rules(df)
# df.head()

# Extracting the default table can be performed using the default table method. The default rules
# method is contained within this method, therefore the default_table method can be run individually
# after the overall dataset (using build_dod_all method) has been created

# Code retained to highlight how the method can be applied
# default_table = stmd.build_dod().default_table(df)
# default_table.shape

# Create the default n12m column
# Each of the methods that are mentioned above are combined into the method default_n12m_all. This
# method is used to create the default flow and perform the operations required to develop the 
# variable "def_n12m"
df = stmd.build_dod().default_n12m_all(df)
df.loc[(df['account_no'] == 000000000)].head(20) # example account to show how the dataset has been created

# C. Create the ODR curve
# Create the variables used within the ODR calculation. Method allows for the 
# aggregation of the two key variables within the ODR calculation (# perf and # default flow n12m)
def summary(x):
    result = {
                'perf': (np.where(x['DEFAULT']==0,1,0)).sum()
                ,'def': (np.where((x['DEFAULT']==0) & (x['def_n12m']==1),1,0)).sum()
            }
    return pd.Series(result).round(4)

# Apply the summary method grouped by the time period variable "month"
df_s1 = df.groupby(['month']).apply(summary)
df_s1.head()

# Create the ODR variable
df_s1['ODR'] = df_s1['def'] / df_s1['perf']
df_s1.head()

# NOTE : creating the output file. If an alternative version is required please re-name
def output_file(filename: str, df):
    if Path(os.getcwd() + '/' + filename).is_file():
        print("File exists")
    else:
        print("File does not exist. Creating.")
        # Create the file
        df.to_csv(filename)

# NOTE : when creating the output file make sure not to over-write existing output file
output_file('odr_mth.csv', df_s1)

# Create the final ODR values for the model
# 1) Keep only the quarter end months
# 2) Make the date a backward looking value i.e. add one year to each value
df_s2 = df_s1.copy()

# Add one year to the datetime index. NOTE: care must be taken not to re-run this more than once as the
# index will keep increasing by the time stamp applied. 
df_s2.index = df_s2.index + pd.offsets.DateOffset(years=1)
df_s2.head()

# Keep the quarter end months only
df_s2['qtr_end'] = df_s2.index.month % 3
df_s2 = df_s2.loc[(df_s2['qtr_end'] == 0)]
df_s2.head()

# Final output file for the stress testing model analysis - only keep data points which had 12 months of default status 
# available in the future. Check max month from ODR dataset and work backwards
date_filt = df_s2.index <= '2020-12-01'
df_s2 = df_s2.loc[df_s2.index[date_filt],['ODR']]

# NOTE : when creating the final output file make sure not to over-write existing output file
output_file('odr.csv', df_s2)
