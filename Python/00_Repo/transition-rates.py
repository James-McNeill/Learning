"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Create the transition rates using the input data                         |
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

# Import sub-packages
from ._awsathena import (create_cursor)
from ._historicdata import (HistoricData)
from ._methods import (dict_to_list, column_exist, check_var_list, create_date_list)

# Initiate the pandas cursor connection
pandas_cursor = create_cursor()

class transition:
    # Constructor
    def __init__(self):
        self.varList = ['input_variables']
        self.varListMaxStage = ", ".join(['shortened_input_variable_list'])
         
    # Method - extract the input data
    def impData(self, databaseName, tableName, df_meta):
        
        # Confirms if all the variables requested from the constructor match back to 
        # metadata request for the dataset. The reason for the review is that during
        # the time series of a dataset, different variables can be available. Users
        # need to mindful of the list that they are using to check the datasets with.
        check = dict_to_list(df_meta, tableName)
        checkList = [x for x in check['Name']]
        # Create the variable list string
        varList = check_var_list(self.varList, checkList)
        
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT {varList}
                                        FROM {databaseName}.{tableName}
                                        WHERE FILTER1
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
            df['post'] = df['post'].astype('int8')
        except:
            print(f'{tableName} dataset not present')
        return df
    
    # Method - Create the SQL string dynamically
    def stringCon(self, db, tb, startDt='2018-11-01', endDt='2019-12-01'):
        # Date list
        listDates = create_date_list(startDt, endDt)
        # Create the table list
        tl = [tb + x for x in listDates]
        # Appending data to empty list
        stringList = []
        for t in tl:
            stringInput = f"""
                        (
                        SELECT {self.varListMaxStage}
                        FROM {db}.{t}
                        WHERE FILTER1
                        )
                        """
            stringList.append(stringInput)
        # Provide a string value of UNION to create the SQL query
        strOut = "UNION".join(stringList)
        return strOut
    
    # Method - Create the max stage data
    # Find the maximum stage between two dates
    # E.g. start date = 2018_11 and end date = 2019_11, returns the max stage during
    # a 12 month review period.
    def maxStage(self, SQL):
        df = None
        df = pandas_cursor.execute(f"""
                                    select account_no, max(stage) as max_stage
                                    from (
                                        {SQL}
                                        ) 
                                    group by account_no
                                    """
                                   , keep_default_na=True
                                   , na_values=[""]
                                  ).as_pandas()
        return df
    
    # Method - create the final dataset to perform transition rates
    def combineData(self, dfPY, dfCY, maxStage):
        dfComb = None
        # Suffix only added if duplicate variables across each DataFrame. Could create each suffix
        # independently of this merge statement if required.
        dfComb = pd.merge(dfPY[['account_no', 'stage', 'ead','channel_type','product_type']]
                         ,dfCY[['account_no', 'stage', 'ead','interest']]
                         ,how='left'
                         ,on='account_no'
                         ,suffixes=('_s','_e')
                            )
        # Add the maxStage dataset
        dfComb = pd.merge(dfComb
                          ,maxStage
                          ,how='left'
                          ,on='account_no'
                         )
        # Adjust the stage 3 end month as no transitions are allowed to take place. Stage 3 is an 
        # absorbing state
        dfComb['stage_e'] = np.where(dfComb['max_stage'] == 3, 3, dfComb['stage_e'])
        # Convert the stage columns to integers
        dfComb['max_stage'] = dfComb['max_stage'].astype('int8')
        return dfComb
    
    # Method - Create the transition rates
    def transition_rates(self, df):
        df_out = None
        # Create a stacked table output for the transition rates between stages
        df_out = pd.crosstab(index=[df['channel_type']
                                    ,df['product_type']
                                    ,df['stage_s']]
                   ,columns=df['stage_e']
                   ,values=df['ead_s']
                   ,aggfunc='count'
                   ,normalize='index').stack().reset_index().rename(columns={0:'transRate'})
        return df_out
