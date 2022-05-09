#Detailed Panda operations
#website: https://github.com/tirthajyoti/Machine-Learning-with-Python/blob/master/Pandas%20and%20Numpy/Pandas_Operations.ipynb

#%% Loading packages and initializations
import numpy as np
import pandas as pd

labels = ['a','b','c']
my_data = [10,20,30]
arr = np.array(my_data)
d = {'a':10, 'b':20, 'c':30}

print("Labels:", labels)
print("My data:", my_data)
print("Dictionary:", d)

#%% Creating a series (Pandas class)
pd.Series(data=my_data) # Output looks very similar to a NumPy array
pd.Series(data=my_data, index=labels) # Note the extra information about index
pd.Series(arr, labels) # Inputs are in order of the expected parameters (not explicitly named), NumPy array is used for data
pd.Series(d) # Using a pre-defined Dictionary object

#%% What type of values can a Pandas Series hold?
print("\nSampleTitle\n", '-'*25, sep='')
print(pd.Series(arr))
print(pd.Series(labels))
print(pd.Series(data=[sum,print,len]))
print(pd.Series(data=[d.keys, d.items, d.values]))

#%% Indexing and slicing
ser1 = pd.Series([1,2,3,4],['CA','OR','CO','AZ'])
ser2 = pd.Series([1,2,5,4],['CA','OR','NV','AZ'])

print("ValueCASer1", ser1['CA'])
print("ValueAZSer1", ser1['AZ'])
print("ValueNVSer2", ser2['NV'])

print("ValueCASer1", ser1[0])
print("ValueAZSer1", ser1[3])
print("ValueNVSer2", ser2[2])

print("Value for OR, CO and AZ in ser1:\n", ser1[1:4], sep='')

#%% Adding/Merging two series with common indices
ser1 = pd.Series([1,2,3,4],['CA','OR','CO','AZ'])
ser2 = pd.Series([1,2,5,4],['CA','OR','NV','AZ'])
ser3 = ser1+ser2

print(ser3) # add the two series
print(ser1*ser2) # multiply the two series

print(np.exp(ser1)+np.log10(ser2)) # combination of mathematical operations

#%% DataFrame (the Real Meat!)
from numpy.random import randn as rn

#%%Creating and accessing DataFrame
np.random.seed(101)
matrix_data = rn(5,4)
row_labels = ['A','B','C','D','E']
column_headings = ['W','X','Y','Z']

df = pd.DataFrame(data=matrix_data, index=row_labels, columns=column_headings)
#df = pd.DataFrame(data=matrix_data, columns=column_headings)
#df = pd.DataFrame(data=matrix_data, index=row_labels)
print("\nThe data frame looks like\n", '-'*45, sep='')
print(df)

#%%Indexing and slicing (columns)
print(df['X'])
print(type(df['X']))
print(df[['X','Z']])
print(type(df[['X','Z']]))

#%% Creating and deleting a (new) column (or row)
df['New'] = df['X']+df['Z']
df['New (Sum of X and Z)'] = df['X']+df['Z']
print(df)

# dropping a column variable that was created (axis=1)
df = df.drop('New', axis=1) #Notice the axis=1 option, axis=0 is default, so have to change it to 1
print(df)
# dropping a row variable that was created (axis=0)
df1 = df.drop('A')
print(df1)
# using the in-place function to remove column
df.drop('New (Sum of X and Z)', axis=1, inplace=True)
print(df)

#%%Selecting/indexing Rows
print(df.loc['C']) #Label-based 'loc' method can be used for selecting rows
print(df.loc[['B','C']])

#%%Subsetting DataFrame
np.random.seed(101)
matrix_data = rn(5,4)
row_labels = ['A','B','C','D','E']
column_headings = ['W','X','Y','Z']
df = pd.DataFrame(data=matrix_data, index=row_labels, columns=column_headings)

print(df) #The dataframe
print(df.loc['B','Y']) #Element at row and column position
print(df.loc[['B','D'],['W','Y']]) #Subset comprising of rows B and D, and columns W and Y

#%%Conditional selection, index (re)setting, multi-index
#%%Basic idea of conditional check and Boolean DataFrame
print(df)
print(df>0) #Boolean dataframe, were we are checking if the values are greater than 0
print(df.loc[['A','B','C']]>0) #Boolean dataframe for subset
booldf = df>0
print(df[booldf]) #Dataframe indexed by boolean dataframe

#%%Passing boolean series to conditionally subset the DataFrame
matrix_data = np.matrix('22,66,140;42,70,148;30,62,125;35,68,160;25,62,152')
row_labels = ['A','B','C','D','E']
column_headings = ['Age','Height','Weight']

df = pd.DataFrame(data=matrix_data, index=row_labels, columns=column_headings)
print(df)
print(df[df['Height']>65]) #Height >65 inches

booldf1 = df['Height']>65
booldf2 = df['Weight']>145
print(df[(booldf1) & (booldf2)]) #Rows with height and weight filters

print(df[booldf1][['Age','Weight']]) #DataFrame with only Age and Weight columns whose Height > 65 inches

#%% Re-setting and setting index
matrix_data = np.matrix('22,66,140;42,70,148;30,62,125;35,68,160;25,62,152')
row_labels = ['A','B','C','D','E']
column_headings = ['Age','Height','Weight']

df = pd.DataFrame(data=matrix_data, index=row_labels, columns=column_headings)
print(df) # The dataframe
#print(df.reset_index()) # After resetting index, this pushes the row_labels into a column
#print(df.reset_index(drop=True)) # After resetting index, with drop option true, the initial row labels are removed

df['Profession'] = "Student Teacher Engineer Doctor Nurse".split() # Adding a new column
print(df)
print(df.set_index('Profession')) # Setting the profession column as the new index

#%% Multi-indexing
# Index levels
outside = ['G1','G1','G1','G2','G2','G2']
inside = [1,2,3,1,2,3]
hier_index = list(zip(outside, inside))
print(hier_index) # Tuple pairs after the zip and list commands

hier_index = pd.MultiIndex.from_tuples(hier_index)
print(hier_index) # Index hierarchy
print(type(hier_index)) # Index hierarchy type

np.random.seed(101)
df1 = pd.DataFrame(data=np.round(rn(6,3),2), index=hier_index, columns=['A','B','C'])
print(df1)

df1.index.names=['Outer', 'Inner']
print(df1)

#%%Cross-section ('XS') command
print(df1.xs('G1')) # Grabbing a cross section from outer level
print(df1.xs(2,level='Inner')) # Grabbing a cross section from inner level

#%% Missing values
df = pd.DataFrame({'A':[1,2,np.nan], 'B':[5,np.nan,np.nan], 'C':[1,2,3]})
df['States'] = "CA NV AZ".split()
df.set_index('States', inplace=True)
print(df)

#%% Pandas 'dropna' method
print(df.dropna(axis=0)) # Dropping any rows with a NaN value
print(df.dropna(axis=1)) # Dropping any columns with a NaN value
print(df.dropna(axis=0, thresh=2)) # Dropping a row with a minimum 2 NaN value using 'thresh' parameter

#%% Pandas 'fillna' method
print(df.fillna(value='FILL VALUE')) # Filling values with a default value
print(df.fillna(value=df['A'].mean())) # Filling values with a computed value (mean of column A)

#%% GroupBy method
# Create dataframe
data = {'Company':['GOOG','GOOG','MSFT','MSFT','FB','FB'],
        'Person':['Sam','Charlie','Amy','Vanessa','Carl','Sarah'],
        'Sales':[200,120,340,125,243,350]}
df = pd.DataFrame(data)
df

byComp = df.groupby('Company')
print(byComp.mean()) # Mean of group by column
print(byComp.sum()) # Sum of group by column

# Note dataframe conversion of the series and transpose
print(pd.DataFrame(df.groupby('Company').describe().loc['FB']).transpose()) # All in one line of command (Stats for FB)
print(df.groupby('Company').describe().loc[['GOOG', 'MSFT']])

#%% Merging, joining and concatenating
# Concatenation
# Creating data frames
df1 = pd.DataFrame({'A': ['A0', 'A1', 'A2', 'A3'],
                        'B': ['B0', 'B1', 'B2', 'B3'],
                        'C': ['C0', 'C1', 'C2', 'C3'],
                        'D': ['D0', 'D1', 'D2', 'D3']},
                        index=[0, 1, 2, 3])

df2 = pd.DataFrame({'A': ['A4', 'A5', 'A6', 'A7'],
                        'B': ['B4', 'B5', 'B6', 'B7'],
                        'C': ['C4', 'C5', 'C6', 'C7'],
                        'D': ['D4', 'D5', 'D6', 'D7']},
                         index=[4, 5, 6, 7])

df3 = pd.DataFrame({'A': ['A8', 'A9', 'A10', 'A11'],
                        'B': ['B8', 'B9', 'B10', 'B11'],
                        'C': ['C8', 'C9', 'C10', 'C11'],
                        'D': ['D8', 'D9', 'D10', 'D11']},
                        index=[8,9,10,11])

#print(df1)
#print(df2)
#print(df3)

#df_cat1 = pd.concat([df1,df2,df3], axis=0)
#print(df_cat1) # After concatenation along row

#df_cat2 = pd.concat([df1,df2,df3], axis=1)
#print(df_cat2) # After concatenation along column

df_cat2.fillna(value=0, inplace=True)
print(df_cat2) # After filling missing values with zero

#%% Merging by a common 'key'
# The merge function allows you to merge DataFrames together using a similar
# logic as merging SQL tables together
left = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3'],
                     'A': ['A0', 'A1', 'A2', 'A3'],
                     'B': ['B0', 'B1', 'B2', 'B3']})
   
right = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3'],
                          'C': ['C0', 'C1', 'C2', 'C3'],
                          'D': ['D0', 'D1', 'D2', 'D3']})

#print(left)
#print(right)

merge1 = pd.merge(left, right, how='inner', on='key')
print(merge1) # After simple merging with 'inner' method

#%% Merging on a set of keys
left = pd.DataFrame({'key1': ['K0', 'K0', 'K1', 'K2'],
                     'key2': ['K0', 'K1', 'K0', 'K1'],
                        'A': ['A0', 'A1', 'A2', 'A3'],
                        'B': ['B0', 'B1', 'B2', 'B3']})
    
right = pd.DataFrame({'key1': ['K0', 'K1', 'K1', 'K2'],
                               'key2': ['K0', 'K0', 'K0', 'K0'],
                                  'C': ['C0', 'C1', 'C2', 'C3'],
                                  'D': ['D0', 'D1', 'D2', 'D3']})
left
right
pd.merge(left, right, on=['key1', 'key2'])
pd.merge(left, right, how='outer', on=['key1', 'key2'])
pd.merge(left, right, how='left', on=['key1', 'key2'])
pd.merge(left, right, how='right', on=['key1', 'key2'])

#%% Joining
left = pd.DataFrame({'A': ['A0', 'A1', 'A2'],
                     'B': ['B0', 'B1', 'B2']},
                      index=['K0', 'K1', 'K2']) 

right = pd.DataFrame({'C': ['C0', 'C2', 'C3'],
                    'D': ['D0', 'D2', 'D3']},
                      index=['K0', 'K2', 'K3'])
left
right
left.join(right)
left.join(right, how='outer')

#%% Useful operations
df = pd.DataFrame({'col1':[1,2,3,4,5,6,7,8,9,10],
                   'col2':[444,555,666,444,333,222,666,777,666,555],
                   'col3':'aaa bb c dd eeee fff gg h iii j'.split()})
df

#df.head() # Method is for showing first few entries
#print(df['col2'].nunique()) # Finding number of unique values

t1=df['col2'].value_counts()
print(t1)

#%% Applying functions
# Pandas work with 'apply' method to accept any user-defined function
# Define a function
def testfunc(x):
    if (x > 500):
        return (10*np.log10(x))
    else:
        return (x/10)
    
df['FuncApplied'] = df['col2'].apply(testfunc)
print(df)

# Apply works with built-in function too
#df['col3length'] = df['col3'].apply(len)
#print(df)

# Combine 'apply' with lambda expression for in-line calculations
#df['FuncApplied'].apply(lambda x: np.sqrt(x))

# Standard statistical functions directly apply to columns
print('Sum of column:', df['FuncApplied'].sum())
print('Mean of column:', df['FuncApplied'].mean())
print('Std dev of column:', df['FuncApplied'].std())
print('Min and max of column:', df['FuncApplied'].min(), 'and', df['FuncApplied'].max())

#%% Deletion, sorting, list of columns and row names
print(df.columns) # Name of columns
l = list(df.columns) # Column names in a list of strings for later use

# Deletion by 'del' command. This affects the dataframe immediately, unlike drop method
#del df['col3length']
print(df)
df['col3length'] = df['col3'].apply(len)
print(df)

# Sorting and ordering a DataFrame
df.sort_values(by='col2') # inplace=False by default
df.sort_values(by='FuncApplied', ascending=False)  # sort descending

#%% Find Null values or Check for Null values
df = pd.DataFrame({'col1':[1,2,3,np.nan],
                   'col2':[np.nan,555,666,444],
                   'col3':['abc','def','ghi','xyz']})
df.head()
df.isnull()
df.fillna('FILL')

#%% Pivot Table
data = {'A':['foo','foo','foo','bar','bar','bar'],
     'B':['one','one','two','two','one','one'],
       'C':['x','y','x','y','x','y'],
       'D':[1,3,2,5,4,1]}

df = pd.DataFrame(data)
df

# Index out of 'A' and 'B', columns from 'C', actual numerical values from 'D'
df.pivot_table(values='D', index=['A', 'B'], columns=['C'])
# Update the missing values that emerge within the Pivot table
df.pivot_table(values='D', index=['A', 'B'], columns=['C'], fill_value='FILLED')
