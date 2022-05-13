# Performing testing on the HPI datasets from the CSO website
# Import libraries
import pandas as pd
import numpy as np

# Bring in the CSO data
url = "https://ws.cso.ie/public/api.restful/PxStat.Data.Cube_API.ReadDataset/HPM06/CSV/1.0/en/TLIST(M1)"
cso = pd.read_csv(url)
cso.head()

# Display the column names
cso.columns

# Check the values within the column
cso['Statistic'].unique()
cso['UNIT'].unique()
cso['Type of Residential Property'].unique()

# Displaying the cardinality of each column
print(cso.apply(lambda col: col.nunique()))

# Need to filter the CSO dataset to only take
# 1) Statistic = 'Residential Property Price Index',  2) UNIT = 'Base Jan 2005=100'
cso1 = cso[(cso['Statistic'] == 'Residential Property Price Index') 
           & (cso['UNIT'] == 'Base Jan 2005 = 100')]
# Create a DataFrame with only the values required to run the calculation
cso2 = cso1[['Type of Residential Property', '2019M08']]
cso2

# Need to create dictionary for the index categories
list1 = ['National - houses','National excluding Dublin - all residential properties'
         ,'Dublin - all residential properties','Dublin - houses','Dublin - apartments'
         ,'National excluding Dublin - apartments','Border excluding Louth - houses'
         ,'Midland - houses','West - houses','Mid-East including Louth - houses'
         ,'Mid-West including South Tipperary - houses','South-East excluding South Tipperary - houses'
         ,'South-West - houses']
list2 = ['NAT_HOUSES','NAT_EXCLU_DUBLIN_ALL_RESI','DUBLIN_ALL_RESI','DUBLIN_HOUSES'
         ,'DUBLIN_APARTMENTS','NAT_EXCLU_DUBLIN_APARTMENTS','BORDER_REGION_EXCLU_LOUTH'
         ,'MIDLANDS_REGION','WEST_REGION','MID_EAST_REGION_INCL_LOUTH','MID_WEST_REGION'
         ,'SOUTH_EAST_REGION','SOUTH_WEST_REGION']
# Create a dictionary
nuts3_map = {list1[i]:list2[i] for i in range(len(list1))}
# Printing resultant dictionary  
print ("Resultant dictionary is : \n" +  str(nuts3_map)) 

# Map the dictionary values 
cso3 = cso2['Type of Residential Property'].copy()
#cso2['nuts3_map'] = cso2['Type of Residential Property'].map(nuts3_map)
cso3['nuts3_map'] = cso3.map(nuts3_map)
cso3

# Join the index values to a table using the nuts3 mapping
# Perform a left join
df = pd.merge(df_p, cso3[['nuts3_map','2019M08']], how='left', left_on='index_new_nuts3', right_on='nuts3_map')
df
