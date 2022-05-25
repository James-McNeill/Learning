# Creating a concatenated data analysis

# Install the pyathena package
%%capture
!pip install pyathena

# Create connection to AWS Athena
# Import utilities, PyAthena and other modules
import pandas as pd
import time
import sys

from pyathena import connect
from pyathena.pandas.cursor import PandasCursor

# Create a cursor instance
s3_staging_dir = 's3://bucket-eu-west-1-.../.../athena-query-result'
region_name = 'eu-west-1' # Region name
work_group = 'ura' # Work Group name.
pandas_cursor = connect(s3_staging_dir = s3_staging_dir,  region_name = region_name, work_group=work_group).cursor(PandasCursor)

# Set default options for the notebook
pd.set_option('display.max_columns', None)
pd.options.display.float_format = '{:,.4f}'.format # Comma and four decimal places for float variables

# Creating a list of table names by different months
df_prefix = 'db.table_2019_'
dataset_list = []
for i in range(1,13):
    if i <10:
        dataset_list.append(df_prefix + str(0) + str(i))
    else:
        dataset_list.append(df_prefix + str(i))
print(dataset_list)

