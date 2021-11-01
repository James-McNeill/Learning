"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Import the datasets from AWS Athena connection                           |
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
import datetime
from operator import itemgetter

# Import sub-packages
from ._awsathena import (create_cursor)

# Initiate the pandas cursor connection
pandas_cursor = create_cursor()

class datasetImport:
    # Constructor
    def __init__(self):
        self.varList = ['first_list_of_variables']
        self.strFirst = ",".join(self.varList)
        self.secondVarList = varList = ['second_list_of_variables']
        self.strSecond = ",".join(self.secondVarList)
        #print(f'{self.varList}')
        #print(f'{self.strFirst}')
        
    # Method - First data review
    def firstData(self, databaseName, tableName):
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT {self.strFirst}
                                        FROM {databaseName}.{tableName}
                                        WHERE FILTER
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset not present')
        return df
    
    # Method - Second data review
    def secondData(self, databaseName, tableName):
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT {self.strSecond}
                                        FROM {databaseName}.{tableName}
                                        WHERE FILTER2
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset not present')
        return df
    
    # Method - Second 12m PD data review
    def secondPD(self, databaseName, tableName, channel, product):
        """
        secondPD('db','table','Personal','Loans')
        """
        # Initialise tables
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT t1.account
                                            ,t1.pfolio
                                            ,t1.second_12mth_pd as second_12m_pd
                                            ,'{channel}' as channel_type
                                            ,'{product}' as product_type
                                        FROM {databaseName}.{tableName} t1
                                        WHERE substr(pfolio,1,3) in ('FIR','SEC','THR')
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset missing')
        return df
    
    # Combine the second 12m PD data sets
    def second_12m_pd(self, date):
        """
        Combine the four second 12m PD datasets
        """
        # Output dataframe
        df = None
        
        # Input values
        dfs = ['df' + str(x) for x in range(1,5)]
        databaseList = ['db_prod','db_prod','db_prod','db_prod']
        tableList = ['t_one_account_'+date,'t_two_account_'+date,'t_three_account_'+date,'t_four_account_'+date]
        channelList = ['Personal','Personal','Business','Business']
        productList = ['Loans','MTAs','Loans','MTAs']
        
        # Create dictionary of dataframes
        list_of_dfs = {}
        for df, db, tb, ch, pl  in zip(dfs,databaseList,tableList,channelList,productList):
            begin_time = datetime.datetime.now()
            print(f'Start time: {begin_time}, {df} = {db} = {tb}')
            list_of_dfs[df] = self.impPD(db,tb,ch,pl)
            print(f'Run time: {datetime.datetime.now() - begin_time}')
        
        # Extracting the key value pairs
        df1, df2, df3, df4 = itemgetter('df1','df2','df3','df4')(list_of_dfs)
        
        # Concatenate the four second 12m PD model datasets
        frames = [df1, df2, df3, df4]
        df = pd.concat(frames)
        return df
    
    # Method - derived variables to be added to datasets
    def derived_variables(self, df, model=None):
        if model == 'FIRST':
            df['channel_type'] = np.where(df['prod_type'].str[0]=='B','Business','Personal')
            df['product_type'] = np.where(df['product'].isin(['F','L']),'Loans','MTAs')
            df['approach'] = np.where(df['calc']=='IRB','AIRB','STD')
            df['default'] = np.where(df['pd']<1,0,1)
        elif model == 'SECOND':
            df['channel_type'] = np.where(df['prod'].isin(['BC','BL']),'Business Direct','Personal')
            df['product_type'] = np.where(df['prod'].isin(['PL','PL']),'Loans','MTAs')
            df['default'] = np.where(df['stage']<3,0,1)
        else:
            print('Derived variables not added')
        return df
    
    # Method - summary statement for high level checks
    def summary_channel_first(self, df):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        """
        df_s1 = df.groupby(['channel_type']).agg(
                                    {
                                        "account":['count']
                                        ,"dr_prob_exp":['sum']
                                        ,"drv_bal":['sum']
                                        ,"drv_el":['sum']
                                        ,"drv_rwa":['sum']
                                    })
        df_s1.columns = ["_".join(x) for x in df_s1.columns.ravel()]
        return df_s1
    
    # Method - summary statement for high level checks at a default flag level
    def summary_first_default(self, df):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        """
        df_s1 = df.groupby(['channel_type','default_flag']).agg(
                                    {
                                        "account":['count']
                                        ,"dr_prob_exp":['sum']
                                        ,"drv_bal":['sum']
                                        ,"drv_el":['sum']
                                        ,"drv_rwa":['sum']
                                    })
        df_s1.columns = ["_".join(x) for x in df_s1.columns.ravel()]
        return df_s1
    
    # Method - summary statement for creation of PD variables
    def summary_first(self, x):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        Summary by default of the PD variables with exposure weighted outputs
        """
        result = {
            'pd_sum': (x['pd'] * x['drv_ead']).sum() / x['drv_ead'].sum()
            ,'pd_sum1': np.average(x['pd'], weights=x['drv_ead'])
            ,'pd_vol': np.average(x['pd'])
        }
        return pd.Series(result).round(4)
