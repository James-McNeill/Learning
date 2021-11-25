"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Perform multi factor linear regression analysis on the final list of     |
#         independent and dependent variable transformations                       |
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
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
import itertools

class MultiFactor:
    
    # Constructor
    def __init__(self, df_ind, df_ind_list, df_dep, dep, st_date='2009-06-01', end_date='2019-12-01', var_combs=2):
        self.df_ind = df_ind
        self.df_ind_list = df_ind_list
        self.df_dep = df_dep
        self.dep = dep
        self.regr = linear_model.LinearRegression(fit_intercept=False) # Create linear regression object
        self.df_out = pd.DataFrame(columns=['Variable', 'Coeff', 'MSE', 'R2'])
        self.st_date = st_date
        self.end_date = end_date
        self.var_combs = var_combs
    
    # Method - create the merged DataFrame of dependent and independent variables
    def _merge_data(self):
        df = pd.merge(self.df_dep
                      ,self.df_ind
                      ,how="left"
                      ,left_index=True
                      ,right_index=True
                     )
        return df
    
    # Method - create list of variable combinations
    def _variable_combs(self):
        combs = list(itertools.combinations(self.df_ind_list, self.var_combs))
        return combs
    
    # Method - create the model statistics for each column
    def _train_model(self, df):
        for col in self._variable_combs():
            dx = df.loc[:, col].to_numpy()
            dy = df.loc[:, self.dep].to_numpy()
            dy = dy[:, np.newaxis]
            self.regr.fit(dx, dy)
            dy_pred = self.regr.predict(dx)
            self.df_out = self.df_out.append(
                {
                    'Variable' : col,
                    'Coeff' : self.regr.coef_,
                    'MSE' : mean_squared_error(dy, dy_pred),
                    'R2' : r2_score(dy, dy_pred)
                }, ignore_index=True
            )
        return
        
    # Method - run the methods from above
    def main(self):
        df = self._merge_data()
        time_window = np.logical_and(
            df.index >= self.st_date, df.index <= self.end_date
        )
        df1 = df.loc[(time_window)]
        self._train_model(df1)
        return self.df_out.sort_values('R2', ascending=False)
