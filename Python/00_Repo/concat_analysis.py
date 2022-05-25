# Creating a concatenated data analysis

# Install the pyathena package
%%capture
!pip install pyathena

# Create connection to AWS Athena
# Import utilities, PyAthena and other modules
import pandas as pd
import numpy as np
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

# Creating a list of table names using list comprehension
# List comprehension
datasetList = [df_prefix + str(x).zfill(2) for x in range(1,13)]
print(datasetList)

from sys import getsizeof
print("List: {}".format(getsizeof(dataset_list)))
print("List comp: {}".format(getsizeof(datasetList)))

# Working with dates
import datetime
from datetime import date
today = date.today()
print("Todays date: {}".format(today))

#end_date = today - pd.DateOffset(months=13)
end_date = datetime.date(2019,12,31)
print("End date: {}".format(end_date))
start_date = datetime.date(2019,1,1)
print("Start date: {}".format(start_date))
# Interval
from dateutil import relativedelta
interval = relativedelta.relativedelta(end_date,start_date)
print("Interval: {}".format(interval))
print("Interval months: {}".format(interval.months))

# Create a date difference function
def dateDiff(d1, d2):
    '''Date difference between two dates'''
    return (d2.year - d1.year) * 12 + d2.month - d1.month
date1 = datetime.date(2019,1,1)
date2 = datetime.date(2019,12,31)
print("Months: {}".format(dateDiff(date1, date2)))

# Create a date range to test the function - https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html
# generating-ranges-of-timestamps
# dateList = pd.date_range(date1, periods=25, freq="M")
dateList = pd.date_range(date1, date2, freq="M")
print("Date list: \n{}".format(dateList))
print("Date list: \n{}".format(dateList[0]))
# Test the range
testDateRange = [dateDiff(date1, x) for x in dateList]
print("Testing date diff: \n{}".format(testDateRange))

# Create one dataset - example month: 2019_01
df_m = pandas_cursor.execute(
        """
        SELECT account_no
                , current_balance
                , drawdown_dt
                , acc_incep_dt
        FROM db.table_2019_05
        """
        , keep_default_na=True
        , na_values=[""]
        ).as_pandas()
df_m['bal_gt_0'] = np.where(df_m['current_balance']>0, 1, 0)
df_m['tape_date'] = datetime.datetime(2019,1,1)

print("Variable type:\n {}".format(df_m.dtypes))
df_m.head()

# Summary output for testing. NOTE: when additional months are added then the groupby clause will require update
df_m_summ = df_m.groupby(['drawdown_dt','tape_date']).agg(
            {
                "current_balance": [sum,'count']
                ,"bal_gt_0": ['count']
            }
        )
df_m_summ.columns = ["_".join(x) for x in df_m_summ.columns.ravel()]
df_m_summ

# Summarize the data for each month
def summariseData(iDate, iYear, iMonth):
    # Create one dataset - example month: 2019_01
    df_m = pandas_cursor.execute(
            f"""
            SELECT account_no
                    , current_balance
                    , drawdown_dt
                    , acc_incep_dt
            FROM db.table_{iDate}
            """
            , keep_default_na=True
            , na_values=[""]
            ).as_pandas()
    df_m['bal_gt_0'] = np.where(df_m['current_balance'] > 0, 1, 0)
    df_m['tape_date'] = datetime.datetime(iYear, iMonth, 1)
    # Appears to be lots of individual dates, create a new formatted date
    df_m['draw_dt_adj'] = df_m['drawdown_dt'].dt.strftime('%Y-%m')
    
    # Summary output for testing. NOTE: when additional months are added then the groupby clause will require update
    df_m_summ = df_m.groupby(['draw_dt_adj','tape_date']).agg(
                {
                    "current_balance": [sum,'count']
                    ,"bal_gt_0": ['count']
                }
            )
    df_m_summ.columns = ["_".join(x) for x in df_m_summ.columns.ravel()]
    df_m_summ
    return df_m_summ

# Test on two DataFrames
df1 = summariseData('2019_01', 2019, 1)
df2 = summariseData('2019_02', 2019, 2)
frames = [df1,df2]
result = pd.concat(frames)
result

# Run the code until the drawdown_dt column changes format (2019_01 - 2019_04)
df_1 = summariseData('2019_01',2019,1)
df_2 = summariseData('2019_02',2019,2)
df_3 = summariseData('2019_03',2019,3)
df_4 = summariseData('2019_04',2019,4)
frames_1 = [df_1, df_2, df_3, df_4]
result_1 = pd.concat(frames_1)
result_1
#result_1.to_csv('draw_test.csv')

# Concat Analysis class
class ConcatAnalysis():
    # Constructor
    def __init__(self, iDate):
        self.df = None
        self.df_summ = None
        self.iDate = iDate
        self.Year = self.iDate.year
        self.Month = self.iDate.month
        self.yyyy_mm = str(self.Year) + "_" + str(self.Month).zfill(2)
    
    def summariseData(self):
        # Create one dataset - example month: 2019_01
        self.df = pandas_cursor.execute(
                f"""
                SELECT account_no
                        , current_balance
                        , drawdown_dt
                        , acc_incep_dt
                FROM db.table_{self.yyyy_mm}
                """
                , keep_default_na=True
                , na_values=[""]
                ).as_pandas()
        self.df['bal_gt_0'] = np.where(self.df['current_balance'] > 0, 1, 0)
        self.df['tape_date'] = datetime.datetime(self.Year,self.Month,1)
        # Appears to be lots of individual dates, create a new formatted date
        if self.Month < 5:
            self.df['draw_dt_adj'] = self.df['drawdown_dt'].dt.strftime('%Y-%m')
        else:
            self.df['draw_dt_adj'] = self.df['drawdown_dt']

        # Summary output for testing. NOTE: when additional months are added then the groupby clause will require update
        self.df_summ = self.df.groupby(['draw_dt_adj','tape_date']).agg(
                    {
                        "current_balance": [sum,'count']
                        ,"bal_gt_0": ['count']
                    }
                )
        self.df_summ.columns = ["_".join(x) for x in self.df_summ.columns.ravel()]
        return self.df_summ

# List of dates - https://queirozf.com/entries/pandas-time-series-examples-datetimeindex-periodindex-and-timedeltaindex
dates = pd.date_range('2019-01-01','2020-01-01' , freq='1M') - pd.offsets.MonthBegin(1)
print(dates)

#concatdata = ConcatAnalysis(datetime.date(2019,12,1))
print("Number of elements: {}".format(len(dates)))
# Testing the instance of the class statement and understanding the methods / attributes that arise from it
# concatdata = ConcatAnalysis(dates[11])
# concatdata.summariseData()
# concatdata.df_summ

# Creating dictionary of DataFrames - https://stackoverflow.com/questions/48888001/creating-multiple-dataframes-with-a-loop/48888621
dfs = ['df' + str(x) for x in range(1,13)]
print(dfs)
print(dates)
list_of_dfs = {}
for df, file in zip(dfs, dates):
    obj = ConcatAnalysis(file)
    obj.summariseData()
    list_of_dfs[df] = obj.df_summ

# Summary of the dictionary
list_of_dfs

# Concat the files
# df dictionary
# list_of_dfs
print(dfs[:3])
frames_2 = [list_of_dfs[dfs[z]] for z in range(0,12)]
result_2 = pd.concat(frames_2)
result_2.groupby('tape_date').count()

# Appear to be three empty DataFrames
# 2019_06, 2019_08, 2019_10
# Checked AWS Athena, dataset references are there but the datasets are empty

# Display DataFrames in the active session
for i in dir():
    if type(globals()[i]) == pd.DataFrame:
        print(i)

print("Data type: {}".format(type(list_of_dfs)))
print("List: {}".format(getsizeof(list_of_dfs)))

print("List: {}".format(getsizeof(result)))
print("List: {}".format(getsizeof(result_1)))
print("List: {}".format(getsizeof(result_2)))

result_2.info(memory_usage='deep')
