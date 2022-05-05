# Basics of Numpy and Pandas
# Website (https://github.com/tirthajyoti/Machine-Learning-with-Python/blob/master/Pandas%20and%20Numpy/Numpy_Pandas_Quick.ipynb)

#%% DataFrame can be created reading CSV/Excel file
import pandas as pd
import numpy as np

#%% Import data. Excel file is taken from UCI website
df = pd.read_csv('winedata.csv')

#%% Quick checking DataFrames
# Head()
df.head() # Top 5 records/rows/indexes are displayed
#df.head(3) # Select N rows to display

#%% Tail() displays the last N records of a df
df.tail()
#df.tail(2)

#%% sample() display a random selection from a df
df.sample() # 1 record
df.sample(5) # N records

#%% info() metadata on the df
df.info()

#%% describe() summary stats for the df
df.describe()
df.describe().transpose() # transpose the summary stats to ensure the variable names are in the first column

#df_sum = df.describe().transpose() # store the summary stats in a df

#%% Basic descriptive statistics on a DataFrame

#Mean()
df.mean()

#%% std()
df.std()

#%% var()
df.var()

#%% min()
df.min()

#%% Indexing, slicing columns and rows of a DataFrame
print(df['Class'].head(5)) # Print one column
print(df[['Class','Alcohol']].head(5)) # Print multiple columns

#%% Conditional subsetting
df['Class']>2 # Creates a boolean value for each row
df[df['Class']>2] # Displays the records from the boolean

#%% Operations on specific columns/rows
df.head(5)

#%% What is the std of ...
df[['Magnesium','Ash']].std()

#%% What is the range of alcohol content
range_alcohol = df['Alcohol'].max() - df['Alcohol'].min()
print("The range of alcohol content is: ", round(range_alcohol,3))

#%% Top 5 percentile
fla_95 = np.percentile(df['Flavanoids'],95)
df[df['Flavanoids']>=fla_95]
df[df['Flavanoids']>=fla_95][['Ash','Alcohol','Magnesium']].mean()

#%% Create a new column as a function of mathematical operations
df['Alcohol_ash'] = df['Alcohol']**2/df['Ash']
df
df.sort_values(by='Alcohol_ash')

#%% Use inplace=True to make the changes reflected on the original DataFrame
df.sort_values(by='Alcohol_ash', inplace=True)
