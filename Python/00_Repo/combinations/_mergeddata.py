"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Merging the individual dataframes into a final dataframe                 |
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

class MergeData():
    """
    Example of how to run the code
    MergeData(df1, df2, df_12m_pd, 'account_no')
    """
    # Constructor
    def __init__(self, df1, df2, df_12m_pd, pk):
        self.tmp = None
        self.df1 = df1
        self.df2 = df2
        self.df_12m_pd = df_12m_pd
        self.pk = pk
    
    # Method - rename variables to include within the 
    def rename_variables(self, df, model=None):
        if model == 'FIRST':
            df = df.rename(columns=
                       {
                           'accg_id':'account_no'
                           ,'dr_exp':'tot_curr_bal_amt'
                           ,'drv_int':'finance_interest'
                        })
        elif model == 'SECOND':
            df = df.rename(columns={'accg_id':'account_no'})
        else:
            print('Derived variables not added')
        return df
    
    # Define Function - not working correctly
    #def dfName(self, df):
    #    name = [x for x in globals() if globals()[x] is df][0]
    #    return name
    
    # Method - Combine the three DataFrames together
    def CombineData(self):
        # Rename the variables in the DataFrames
        self.df1 = self.rename_variables(self.df1, model='FIRST')
        self.df_12m_pd = self.rename_variables(self.df_12m_pd, model='SECOND')
        
        # Create a list of DataFrames
        dfList = [self.df1, self.df2, self.df_12m_pd]
        
        # Populate the temporary dataset with the df
        self.tmp = dfList[0]
        # Including the enumeration for the suffixes helps to show how many duplicate variables
        # there are between DataFrames
        for i, df_ in enumerate(dfList[1:]):
            # Two methods for adding suffixes. Method 1 adds a number. Method 2 adds a table name reference
            self.tmp = self.tmp.merge(df_, on=self.pk, how='outer', suffixes=("",str(i)))
            #self.tmp = self.tmp.merge(df_, on=self.pk, how='outer', suffixes=("","_"+self.dfName(df_)[:3]))
        return self.tmp
