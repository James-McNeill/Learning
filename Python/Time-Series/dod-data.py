"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Create the DoD dataset required                                          |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@outlook.com"
__status__ = "Test"

# Import packages
import pandas as pd
import numpy as np
import time
import sys
import datetime
import boto3

# Import sub-packages
from ._awsathena import (create_cursor)
from ._methods import (create_date_list)

# Initiate the pandas cursor connection
pandas_cursor = create_cursor()

# Create the AWS Glue connection
client = boto3.client('glue')

class build_dod:
    # Constructor values
    def __init__(self):
        self.var_list = ", ".join(['mort_no','year_month','DEFAULT'])       
    
    # Method - Create a dictionary of DataFrames
    def build_dod_model(self):
        # Extract the dataframe from AWS Athena
        df = pandas_cursor.execute(
            """
            SELECT account_no, 
                month,
                DEFAULT
            FROM DATABASE.default_table
            """
            , keep_default_na=True
            , na_values=[""]
        ).as_pandas()
        # Convert variable data types to improve memory overhead
        df_out = df.copy()
        # Convert some of the variable data types
        convert_dict = {'account_no': 'int64',
                        'DEFAULT': 'int8'
                       }
        df_out = df_out.astype(convert_dict)
        # Sort the order of the loans by unique reference and time stamp
        df_out = df_out.sort_values(by=['account_no','month'], ignore_index=True)
        # Delete the objects that are not required
        del df
        
        return df_out
    
    # Method - SQL string concatenation
    def string_con(self, db, tb, startDt='2020-04-01', endDt='2021-01-01'):
        """
        Perform SQL string concatenation to create a combined UNION statement. This enables
        the SQL string to be used as one statement when querying the AWS Athena engine.
        """
        # Date list
        listDates = create_date_list(startDt, endDt)
        # Create the table list
        tl = [tb + x for x in listDates]
        # Appending data to empty list
        stringList = []
        for t in tl:
            stringInput = f"""
                            (
                            SELECT distinct mort_no, year_month, DEFAULT
                            FROM {db}.{t}
                            WHERE filter_variable = 'N'
                            GROUP BY {self.var_list}
                            )
                            """
            stringList.append(stringInput)
        # Provide a string value of UNION to create the SQL query
        strOut = "UNION".join(stringList)
        return strOut
    
    # Method - combine the SQL strings together
    def combine_capital(self, SQL):
        df = None
        df = pandas_cursor.execute(f"""
                                    select mort_no as account_no, year_month, DEFAULT
                                    from (
                                        {SQL}
                                        ) 
                                    """
                                   , keep_default_na=True
                                   , na_values=[""]
                                  ).as_pandas()
        return df
    
    # Method - concatentate the DoD and latest tables
    def build_dod_all(self, db, tb):
        df = None
        df_cap_comb = self.combine_capital(self.string_con(db, tb))
        # Add the month variable to dataframe
        df_cap_comb['month'] = pd.to_datetime(df_cap_comb['year_month'], format='%Y%m')
        df_pdod = self.build_dod_model()
        
        # Stack the 2020 data to the DoD dataset
        df = pd.concat([df_pdod.loc[:, ['account_no','month','DEFAULT']]
                        ,df_cap_comb.loc[:, ['account_no','month','DEFAULT']]]
                       )
        # Convert some of the variable data types
        convert_dict = {'account_no': 'int64',
                        'DEFAULT': 'int8'
                       }
        df = df.astype(convert_dict)
        # Sort the order of the loans by unique reference and time stamp
        df = df.sort_values(by=['account_no','month'], ignore_index=True)
        
        # Delete the objects that are not required
        del df_cap_comb
        
        return df
    
    # Method - create the columns needed to create the default flow
    def default_rules(self, df):
        # Check to make sure that the current loan and previous loan match
        df['acct_c'] = np.where(df.account_no.shift(1) == df.account_no, 1, 0)
        # Numpy condition to check for matching loan and flow into basel default
        df_cond_np = np.array((df.acct_c == 1) & ((df.DEFAULT.shift(1) == 0) &  (df.DEFAULT == 1)))
        # Apply the numpy array to create a default flow variable
        df['def_flow'] = np.where(df_cond_np, 1, 0)
        return df
    
    # Method - create the default table
    def default_table(self, df):
        self.default_rules(df)
        df_out = df.loc[(df['def_flow'] == 1), ['account_no', 'month']]
        df_out['default_month'] = df_out['month']
        return df_out
    
    # Method - merge the default table to the overall table
    def merge_default_date(self, df):
        df = df.merge(self.default_table(df),
                      on=['account_no', 'month'],
                      how='outer'
                     )
        return df
    
    # Method - backfill the default date column
    def backfill_default_date(self, df):
        df['default_month'] = df.groupby('account_no')['default_month'].pipe(lambda x: x.bfill())
        return df
    
    # Method - create the default difference by month
    def default_date_diff(self, df):
        df['def_dates_diff'] = (df['default_month'].dt.year - df['month'].dt.year) * 12 + (df['default_month'].dt.month - df['month'].dt.month)
        return df
    
    # Method - create the default next 12 months
    def default_n12m(self, df):
        df['def_n12m'] = np.where(df['def_dates_diff'] <= 12, 1, 0)
        return df
    
    # Method - run all of the methods to create the default next 12 months variable
    def default_n12m_all(self, df):
        df_out = None
        df_out = self.merge_default_date(df)
        df_out = self.backfill_default_date(df_out)
        df_out = self.default_date_diff(df_out)
        df_out = self.default_n12m(df_out)
        return df_out
