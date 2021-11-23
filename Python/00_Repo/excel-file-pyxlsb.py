# Importing excel files into Python
# Using the "pyxlsb" module allows the user to import an xlsb file format

# Reference website: https://pypi.org/project/pyxlsb/
import pyxlsb
import pandas as pd
import numpy as np

# Load the workbook
excelFile = 'excelFile.xlsb'

# Working with the read_excel method to import the data from a worksheet
excel = pd.read_excel(excelFile, engine='pyxlsb', sheet_name='sheet1')
print(f'{excel.shape}')
print(f'{excel.columns}')

# Display the data types for the columns
excel.dtypes

# Checking the missing values for each data points
miss_value = excel[excel['ead']=='.']
miss_value

# Review the object features
objList = excel.select_dtypes(include='object').columns

# Creating a dataframe with the missing values by feature
missValues = pd.DataFrame(columns=['Var','Count'])
for o in objList:
    missValues = missValues.append({'Var': o 
                                    ,'Count': sum(excel[o].str.find('.')==0)
                                    }
                                  ,ignore_index=True)

# Check the missing values that have been created
missValuesVars = missValues[missValues['Count']>0]
missList = [x for x in missValuesVars['Var']]

# Convert the feature data types for the missList
for m in missList:
    excel[m] = np.where(excel[m].str.find(".")==0, 0, excel[m]).astype(str).astype(float)
excel.head(10)
