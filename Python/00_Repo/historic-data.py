"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Historic Meta data review                                                |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@ulsterbank.com"
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

# Initiate the pandas cursor connection
pandas_cursor = create_cursor()

# Create the AWS Glue connection
client = boto3.client('glue')

class HistoricData:
    '''
    Historic data class that can be used to review the meta data for tables.
    Examples
    ---
    repu alias imported the class
    # Extract the metadata for specific datasets to show DataFrame format
    test_data = repu.HistoricData('2017-11-01','2020-12-01').metaData("db","table_prefix")
    
    # Extract metadata for all datasets being reviewed and store in dictionary
    hist = repu.HistoricData('2017-11-01','2020-12-01')
    dfDict = hist.dictDataframes()
    # Extracts the keys and values to create new variables to assign.
    # The DataFrames have now been created
    for k,v in dfDict.items():
        exec(k+'=v')
        print(f'{k}')
    # Confirm that the full history of datasets was created
    framesList = [dfDict[hist.dfs[z]] for z in range(0,len(hist.dfs))]
    result = pd.concat(framesList)
    result.groupby(['DatabaseName','TableName']).count()
    # Missing datasets for review
    result_empty = result[result['Rows']==0]
    result_empty
    '''
    # Constructor values
    def __init__(self, start, end):
        self.start = start
        self.end = end
        self.databaseList = ['db1','db_test','db_prod','db_prod'] # list of databases used within AWS Athena that map to the table list below
        self.tableList = ['test1','test2','test1','test2'] # list of table names
        self.dfs = ['df' + str(x) for x in range(1,len(self.databaseList)+1)] # creating the string variable values for the mapping later in the module    
    
    # Method - Create metaData DataFrame output on input database tables
    def metaData(self, databaseName, tableName):
        # Create date range to review
        dates = pd.date_range(self.start,self.end, freq='1M') - pd.offsets.MonthBegin(1)
        listDates = [str(x.year)+"_"+str(x.month).zfill(2) for x in dates]
        # Initialise tables
        temp = None
        tableList = [tableName + x for x in listDates]
        df = pd.DataFrame(columns=['Name','TableName','DatabaseName','CreateTime','Cols','Rows','ColNames']) # Create empty MetaData table

        for tb in tableList:
            try:
                temp = pandas_cursor.execute(
                                            f"""
                                            SELECT count(*) as vol
                                            FROM {databaseName}.{tb}
                                            """
                                            , keep_default_na=True
                                            , na_values=[""]
                                            ).as_pandas()
                mD = client.get_table(DatabaseName = databaseName, Name = tb)
                df = df.append({"Name": mD.get('Table').get('Name')
                                    ,"TableName": tableName
                                    ,"DatabaseName": mD.get('Table').get('DatabaseName')
                                    ,"CreateTime": mD.get('Table').get('CreateTime')
                                    ,"Cols": len(mD.get('Table').get('StorageDescriptor').get('Columns'))
                                    ,"Rows":int(temp['vol'])
                                    ,"ColNames": list(x for x in mD.get('Table').get('StorageDescriptor').get('Columns'))
                                     }
                                    ,ignore_index=True)
            except:
                df = df.append({"Name":tb
                                ,"TableName": tableName
                                ,"DatabaseName": databaseName
                                ,"CreateTime":0
                                ,"Cols":0
                                ,"Rows":0
                                ,"ColNames":[]
                                }
                                ,ignore_index=True)
        return df
    
    # Method - Create a dictionary of DataFrames
    def dictDataframes(self):
        # Dictionary of DataFrames
        list_of_dfs = {}
        for df, db, tb  in zip(self.dfs, self.databaseList, self.tableList):
            begin_time = datetime.datetime.now()
            print(f'Start time: {begin_time}, {df} = {db} = {tb}')
            list_of_dfs[df] = self.metaData(db,tb)
            print(f'Run time: {datetime.datetime.now() - begin_time}')
        return list_of_dfs
