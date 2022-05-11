# Advanced Pandas Operations
# website (https://github.com/tirthajyoti/Machine-Learning-with-Python/blob/master/Pandas%20and%20Numpy/Advanced%20Pandas%20Operations.ipynb)

#%% Import libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#%% Exercise 1: Load and examine a superstore sales dataset
df = pd.read_excel('Sample - Superstore.xls')
df.head(10)

df.drop('Row ID',axis=1,inplace=True)
df.shape

#%% Ex2: subsetting the dataframe
df_subset = df.loc[[i for i in range(5,10)],['Customer ID','Customer Name','City','Postal Code','Sales']]
df_subset

#%% Ex3: determining stats on sample
df_subset = df.loc[[i for i in range(100,200)],['Sales','Profit']]
df_subset.describe()

# Creating a summary chart
df_subset.plot.box()
plt.title("Boxplot of sales and profit",fontsize=15)
plt.ylim(0,500)
plt.grid(True)
plt.show()

#%% Ex4: A useful function - unique
df['State'].unique()
df['State'].nunique()
df['Country'].unique()
df.drop('Country',axis=1,inplace=True)

#%% Ex5: Conditional selection and boolean filtering
df_subset = df.loc[[i for i in range(10)],['Ship Mode','State','Sales']]
df_subset
df_subset>100 # Boolean for variables
df_subset[df_subset>100] # Sales less than 100 are now NaN
df_subset[df_subset['Sales']>100] # Keep only sales >100 records
df_subset[(df_subset['State']!='California') & (df_subset['Sales']>100)]

#%% Ex6: Setting and re-setting index
# Already completed before

#%% Ex7: GroupBy method
df_subset = df.loc[[i for i in range(10)],['Ship Mode','State','Sales']]
df_subset

byState = df_subset.groupby('State')
byState

#print(byState.mean(), byState.sum())
print(byState.mean())
print(byState.sum())

print(pd.DataFrame(df_subset.groupby('State').describe().loc['California']).transpose())

df_subset.groupby('Ship Mode').describe().loc[['Second Class','Standard Class']]
pd.DataFrame(byState.describe().loc['California'])
byStateCity = df.groupby(['State','City'])
byStateCity.describe()['Sales']

#%% Ex8: Missing values in Pandas
# This first sheet name option for the excel file didn't work
#df_missing = pd.read_excel("Sample - Superstore.xls",sheet_name="Missing")
df_missing = pd.read_excel(open('Sample - Superstore.xls','rb'), sheetname="Missing")
df_missing

df_missing.isnull()

# Displaying the number of missing values using a function
for c in df_missing.columns:
    miss = df_missing[c].isnull().sum()
    if miss > 0:
        print("{} has {} missing value(s)".format(c,miss))
    else:
        print("{} has NO missing value!".format(c))

#%% Ex9: Filling missing values with fillna()
df_missing.fillna('FILL')
df_missing[['Customer','Product']].fillna('FILL') # Fill value for character variables
df_missing['Sales'].fillna(method='ffill') # Forward fill for numeric variables
df_missing['Sales'].fillna(method='bfill') # Backward fill for numeric variables
df_missing['Sales'].fillna(df_missing.mean()['Sales']) # Fill with average of non-null values

#%% Ex10: Dropping missing values with dropna()
df_missing.dropna(axis=0) # Drop the rows with missing values
df_missing.dropna(axis=1) # Drop the columns with missing values
df_missing.dropna(axis=1, thresh=10) # Drop the columns with missing values, a threshold exists

#%% Ex11: Outlier detection using simple statistical test
df_sample = df[['Customer Name','State','Sales','Profit']].sample(n=50).copy()

#%% Assign a wrong negative value in a few places
df_sample['Sales'].iloc[5]=-1000.0
df_sample['Sales'].iloc[15]=-500.0

df_sample.plot.box()
plt.title("Boxplot of sales and profit", fontsize=15)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
plt.grid(True)

#%% Ex12: Concatenation
df_1 = df[['Customer Name','State','Sales','Profit']].sample(n=4)
df_2 = df[['Customer Name','State','Sales','Profit']].sample(n=4)
df_3 = df[['Customer Name','State','Sales','Profit']].sample(n=4)

df_3

#%% Cat1: by row
df_cat1 = pd.concat([df_1,df_2,df_3], axis=0)
df_cat1

#%% Cat2: by column
df_cat2 = pd.concat([df_1,df_2,df_3], axis=1)
df_cat2

#%% Ex13: Merging by a common key
df_1 = df[['Customer Name','Ship Date','Ship Mode']][0:4]
df_1

df_2 = df[['Customer Name','Product Name','Quantity']][0:4]
df_2

pd.merge(df_1,df_2,on='Customer Name',how='inner')

pd.merge(df_1,df_2,on='Customer Name',how='inner').drop_duplicates()

df_3 = df[['Customer Name','Product Name','Quantity']][2:6]
df_3

pd.merge(df_1,df_3,on='Customer Name',how='inner').drop_duplicates()
pd.merge(df_1,df_3,on='Customer Name',how='outer').drop_duplicates()

#%% Ex14: Join method
df_1 = df[['Customer Name','Ship Date','Ship Mode']][0:4]
df_1.set_index(['Customer Name'],inplace=True)
df_1

df_2 = df[['Customer Name','Product Name','Quantity']][2:6]
df_2.set_index(['Customer Name'],inplace=True)
df_2

# Left join for df_1, keep everything from df_1 and include information from df_2
df_1.join(df_2,how='left').drop_duplicates()

# Right join for df_1, keep everything from df_2 and include information from df_1
df_1.join(df_2,how='right').drop_duplicates()

# Inner join
df_1.join(df_2,how='inner').drop_duplicates()

# Outer join (full join)
df_1.join(df_2,how='outer').drop_duplicates()

#%% Miscellaneous useful methods
# Ex15: Randomized sampling - sample method
df.sample(n=5) # number of records to keep
df.sample(frac=0.001) # percentage of records to keep
df.sample(frac=0.001,replace=True) # percentage of records to keep and always replace

#%% Ex16: Pandas value_count method to return unique records
df['Customer Name'].value_counts()[:5] # Number returns the top N values, however multiple records with the same count will not be included as it depends on the order of values within the dataset

#%% Ex17: Pivot table functionality - pivot_table
df_sample=df.sample(n=100)
df_sample.pivot_table(values=['Sales','Quantity','Profit'],index=['Region','State'],aggfunc='mean')

#%% Ex18: Sorting by particular column
df_sample=df[['Customer Name','State','Sales','Quantity']].sample(n=15)
df_sample

df_sample.sort_values(by='Sales')
df_sample.sort_values(by=['State','Sales'])

#%% Ex19: Flexibility for user-defined function with apply method
def categorize_sales(price):
    if price < 50:
        return "Low"
    elif price < 200:
        return "Medium"
    else:
        return "High"

df_sample=df[['Customer Name','State','Sales']].sample(n=100)
df_sample.head(10)

df_sample['Sales Price Category']=df_sample['Sales'].apply(categorize_sales)
df_sample.head(10)

df_sample['Customer Name Length']=df_sample['Customer Name'].apply(len)
df_sample.head(10)

df_sample['Discounted Price']=df_sample['Sales'].apply(lambda x:0.85*x if x > 200 else x)
df_sample.head(10)
