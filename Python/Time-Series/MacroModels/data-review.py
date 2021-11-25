# Reviewing the data required for the model development

# Import utilities, PyAthena and other modules
import pandas as pd
import numpy as np
import datetime
import time
import sys
import os
import plotly.express as px

# Print current working directory location
print(os.getcwd()+'/')
# Connect to the repo package folder to use in this Notebook
sys.path.append("/home/ec2-user/SageMaker/s3-user-bucket/..../")

# Import the sub-packages
from stmd import utils as stmd

# Formatting for the float variables
pd.options.display.float_format = '{:,.5f}'.format

# Show all cell outputs requested
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"

# Set default options for the notebook
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.options.display.float_format = '{:,.4f}'.format # Comma and four decimal places for float variables

# Create the pandas cursor object
pandas_cursor = stmd.create_cursor()

# Store the start time of the code process
begin_time = datetime.datetime.now()

# Bring in the default dataset
df_imp0 = pandas_cursor.execute(
            """
            SELECT account_no
                ,month
                ,brand
                ,default_flag
                ,current_balance
            FROM DATABASE.default_table
            """
            , keep_default_na=True
            , na_values=[""]
            ).as_pandas()

# Display the shape of the DataFrame and run time required to process the SQL query
print(df_imp0.shape, datetime.datetime.now() - begin_time)

# Transform the variable data types to reduce the memory being used. Future work : bring into module of package
df_imp = df_imp0.copy()
# Convert some of the variable data types
convert_dict = {'account_no': 'int64',
                'brand': 'category',
                'default_flag': 'int8',
                'current_balance': 'float'
               }
df_imp = df_imp.astype(convert_dict)
# Show the dataset size after converting the column types
df_imp.info(memory_usage='deep')

# Delete the dataframe that is not required anymore to release memory
del df_imp0

# Check to see the latest date of data available for the default dataset
df_imp.describe(include='all', datetime_is_numeric=True)

# Merging DataFrames for comparison purposes
df_imp_comp = pd.merge(df_dod[['account_no','month','DEFAULT']]
                        ,df_imp[['account_no','month','default_flag']]
                         ,how='left'
                         ,on=['account_no','month']
                            )

# Compare the two default flags - they match back perfectly for the months were there is cross-over
df_imp_comp['default_check'] = np.where(df_imp_comp['default_flag']==df_imp_comp['DEFAULT'], 1, 0)
df_imp_comp.groupby(['default_check','month'])['account_no'].count()

# Perform check on the MetaData of the default dataset's
%time proxy_dod = stmd.HistoricData('2020-03-01', '2021-04-01').metaData("DATABASE", "input_table_")
proxy_dod

# Comparing DataFrames
df_cap_comp = pd.merge(df_pdod[['account_no','month','DEFAULT']]
                       ,df_pdod1[['mort_no','DEFAULT']]
                       ,how='outer'
                       ,left_on=['account_no']
                       ,right_on=['mort_no']
                       ,suffixes=['_p', '_c']
                       )

# Compare the default flags between the two datasets
df_cap_comp.groupby(['DEFAULT_p', 'DEFAULT_c'])['mort_no'].count()

# Add in a comparison variable to check for any differences between the two datasets for this variable
df_cap_comp['compared'] = np.where(df_cap_comp['DEFAULT_p'] != df_cap_comp['DEFAULT_c'], 1, 0)
df_cap_comp.groupby(['compared'])['mort_no'].count()

# Understand the differences between the default rules
check = pd.crosstab(index=df_cap_comp['month']
           ,columns=[df_cap_comp['DEFAULT_p'],df_cap_comp['DEFAULT_c']]
           ,values=df_cap_comp['account_no']
           ,aggfunc='count'
            )
check

# Summary pivot table
check = pd.pivot_table(
    df_cap_comp,
    values='account_no',
    index='month',
    columns=['DEFAULT_p','DEFAULT_c'],
    aggfunc='count'
)
check.columns = [str(x) + "_" + str(y) for (x,y) in check.columns.tolist()]
check.index.name = None
check

# Confirm column and index values
check.columns
check.index

# Plot the extra defaults in each rule
date_np = check.index >= '2006-04-01'
check1 = check[date_np]
# check1
fig = px.line(check1, x=check1.index, y=['0_1','1_0'])
fig.show()

# Reviewing the differences between the previous DoD and the new DoD
check1['diff'] = check['0_1'] - check['1_0']
check1.head()

# Visualise the differences
fig = px.line(check1, x=check1.index, y='diff')
fig.show()
fig = px.bar(check1, x=check1.index, y='diff')
fig.show()

# Check the stock % for the first and second definitions
check1['total'] = check1['0_0'] + check1['0_1'] + check1['1_0'] + check1['1_1']
check1['first_pct'] = (check1['1_0'] + check1['1_1']) / check1['total']
check1['second_pct'] = (check1['0_1'] + check1['1_1']) / check1['total']
check1

# Visualise the stock %
fig = px.line(check1, x=check1.index, y=['first_pct','second_pct'])
fig.show()
