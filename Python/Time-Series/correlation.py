"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Perform correlation analysis on the final list of independent and        |
#         dependent variable transformations                                       |
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

class Correlation:
  '''
  Perform a correlation analysis between the independent and dependent variables.
  :df_ind = (DataFrame) final list of independent variable transformations
  :df_dep = (DataFrame) final dependent variable transformation
  :dep = (str) string value of the dependent variable name
  
  TODO: Could put this analysis into a Notebook within this repository. Application of the code
    # Run the correlation analysis
    df_ind_ = df_ind3[df_indep_list] # 
    df_dep_ = df_dep.loc[:,['ODR_X']] # the final dependent variable transformation
    dep = 'ODR_X'
    # Run the Correlation class to create the correlation of independent variables with the dependent variable
    df_corr = stmd.Correlation(df_ind_, df_dep_, dep).main() # stmd represents the package reference alias
    df_corr # displays a pivot table of the correlation values
    
    sns.heatmap(df_corr, annot=True); # produces a heatmap of the pivot table    
  '''
    
    # Constructor
    def __init__(self, df_ind, df_dep, dep):
        self.df_ind = df_ind
        self.df_dep = df_dep
        self.dep = dep
    
    # Method - create the merged DataFrame of dependent and independent variables
    def _merge_data(self):
        df = pd.merge(self.df_dep
                      ,self.df_ind
                      ,how="left"
                      ,left_index=True
                      ,right_index=True
                     )
        return df
    
    # Method - create the correlation DataFrame
    def _correlation_test(self, df):
        # Create correlations
        df1 = df.corr()[self.dep][:]
        df1 = df1.to_frame()
        # Adjust DataFrame
        df1.reset_index(inplace=True)
        df1 = df1.rename(columns = {'index':'var_trans', self.dep:'Dep_corr'})
        return df1
    
    # Method - add the required group by columns
    def _groupby(self, df):
        # Add the required group by columns
        corr = df.var_trans.str.split('_', expand = True)
        # Add variable values back to the dataframe
        df['variable'] = corr[0] + '_' + corr[1]
        df['trans'] = corr[2]
        df['lag'] = corr[3]
        return df
    
    # Method - create the pivot table summary
    def _pivot(self, df):
        # Create a pivot table to display the range of correlation values for each variable by lag and transformation
        df_pivot = pd.pivot_table(df,
                                  values="Dep_corr",
                                  index=["variable", "lag"],
                                  columns=["trans"]
                                 )
        return df_pivot
    
    # Method - run the methods from above
    def main(self):
        df = self._merge_data()
        df1 = self._correlation_test(df)
        df1 = self._groupby(df1)
        df1 = self._pivot(df1)
        return df1
    
    # Run the process steps
    if __name__ == "__main__":
        main()
