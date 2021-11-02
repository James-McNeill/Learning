"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Perform uniqueness testing for dataframes                                |
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

# Create DuplicateData class object
class duplicateData():
    '''
    Example
    ---
    # Allows the user to extract the named key values from the dictionary
    from operator import itemgetter
    # Run the class object
    jsondata = dict()

    # For the unique key of 'accg_unit_id'
    for i, t in enumerate([df1, df_12m_pd],start=1):
        dups = repu.duplicateData(t,'accg_unit_id')
        dups.duplicateReview()
        jsondata['dict' + str(i)] = dups.dict

    for i, t in enumerate([df_cy, df_py],start=3):
        dups = repu.duplicateData(t,'account_no')
        dups.duplicateReview()
        jsondata['dict' + str(i)] = dups.dict

    jsondata.keys()
    # Extract the dictionary data output's
    for i in jsondata.keys():
      print(i, itemgetter('uniquetest','uniquecount','duplicatesum')(jsondata.get(i)))
    '''
    # Constructor
    def __init__(self, df, pk):
        self.tmp = None
        self.uniqueTest = None
        self.duplicateCount = None
        self.duplicates = None
        self.duplicateSum = None
        self.df = df
        self.pk = pk
        #self.df.df_name = str(df)
        self.dict = dict()
    
    def duplicateReview(self):
        # Check for uniqueness
        self.uniqueTest = pd.Series(self.df[self.pk]).is_unique

        # Assign a duplicate boolean value to new column. Using option keep=False, ensures that all duplicates
        # are flagged. Option subset= allows for the specific column to be identified
        self.tmp = self.df.copy()
        self.tmp['duplicate'] = self.tmp.duplicated(keep=False,subset=[self.pk])
        self.duplicateCount = self.tmp['duplicate'].value_counts().to_string()
        
        # Create extra outputs if duplicate values exist
        if self.uniqueTest == False:
            
            # Create a DataFrame with the only duplicate values
            self.duplicates = self.tmp[self.tmp['duplicate']==True]
        
            # Summarise the duplicate DataFrame
            self.duplicateSum = self.duplicates.groupby([self.pk]).size().sort_values(ascending=False).to_frame('vol')
        else:
            self.duplicates = None
            self.duplicateSum = None
        
        # Dictionary content
        #self.dict['tableid'] = self.df.df_name
        self.dict['uniquetest'] = str(self.uniqueTest)
        self.dict['uniquecount'] = self.duplicateCount
        self.dict['duplicatesum'] = self.duplicateSum
        self.dict['duplicate'] = self.duplicates
        
