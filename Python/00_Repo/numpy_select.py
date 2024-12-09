import pandas as pd
from openpyxl.workbook import Workbook
import numpy as np

# Import data
df_excel = pd.read_excel('regions.xlsx')
df_csv = pd.read_csv('Names.csv', header=None)
df_txt = pd.read_csv('data.txt', delimiter='\t')

# Update column names for Names.csv file
df_csv.columns = ['First', 'Last', 'Address', 'City', 'State', 'Area Code', 'Income']

# Add an income tax variable and tax owned
df_csv1 = (
    df_csv
    .assign(Tax_pct=np.select([(df_csv.Income > 10000) & (df_csv.Income < 40000),
                               (df_csv.Income > 40000) & (df_csv.Income < 80000),
                               df_csv.Income > 80000]
                              ,[.15, .2, .25]
                              ,default=np.nan)
            ,tax_owed=lambda df_: df_.Income * df_.Tax_pct
            )
    )
