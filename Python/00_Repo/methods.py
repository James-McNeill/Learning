"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - List of generic methods to use in all packages                           |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@outlook.com"
__status__ = "Test"

# Import modules
import pandas as pd

# Method 1 - from dictionary to list
def dict_to_list(df, tblname, dictkey='Name', tblvariable='ColNames'):
    """
    Explode the list of variables from dataframe column to dictionary parameters.
    :df = dataframe with the MetaData for review
    :tblname = dataset name to review
    :dictkey = value that is used for the column names
    :tblvariable = df column containing the list of variables which reference dictionary
    Example:
    INSERT EXAMPLE
    """
    df1 = None
    df_out = None
    
    df1 = df.loc[df[dictkey]==tblname,[tblvariable]]
    df1 = df1.explode(tblvariable)
    listDict = df1[tblvariable].values.tolist()
    df_out = pd.DataFrame(listDict)
    return df_out

# Method 2 - Does column listing exist
def column_exist(col_check, list_names):
    """
    Check if the columns are within a list from the MetaData extract
    :col_check = list of columns to check for
    :list_names = list of columns from the MetaData search
    TODO: switch off the print statements used during testing
    """
    # Overall check
    if set(col_check).issubset(list_names):
        print('Yes')
    else:
        print('No')
    
    # Create a list of variables that are available to use
    new_list = []
    miss_list = []
    for i in col_check:
        if i in list_names:
            new_list.append(i)
            #print('Yes')
        else:
            miss_list.append(i)
            #print('No')
    print(f'List of available variables:\n {new_list}')
    print(f'List of missing variables:\n {miss_list}')
    return new_list

# Method 3 - create a variable list for checking
def check_var_list(var_list, list_names):
    """
    Create a final list of variables which are available within the dataset reviewed
    :var_list = list of required variables expected by user
    :list_names = list of variables from the MetaData
    Output: string list containing the variables that are available for use
    """
    out_list = column_exist(var_list, list_names)
    strout = ", ".join(out_list)
    return strout

# Method 4 - create a date list
def create_date_list(startDt='2020-11-01', endDt='2020-12-01'):
    """
    Create a date list ranging from start to end dates. Date output format = yyyy_mm
    :startDt = beginning date for the range
    :endDt = end date for the range
    To run the current method requires a minimum one month difference between dates
    FUTURE: Could provide more of the common date movements e.g. (M, Q, Y), and have these
    added to the functionality with a keyword parameter
    """
    dates = pd.date_range(startDt, endDt, freq='1M') - pd.offsets.MonthBegin(1)
    listDates = [str(x.year)+"_"+str(x.month).zfill(2) for x in dates]
    return listDates

# Method 5 - proportion of missing values per column
def missing_columns(df):
    for col in df.columns:
        miss = df.isnull().sum()
        miss_per = miss / len(df)
    return miss_per

# missing_columns(ber_data1)
