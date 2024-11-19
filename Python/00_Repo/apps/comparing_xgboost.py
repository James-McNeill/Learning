# -*- coding: utf-8 -*-
"""
Created on Thu May 25 14:33:33 2023

@author: jamesmcneill
"""

from sklearn.datasets import load_iris
import xgboost as xgb
from xgboost import plot_importance
# import xgbfir
import matplotlib.pyplot as plt

# loading database
iris = load_iris()

# doing all the XGBoost magic
xgb_cmodel = xgb.XGBClassifier().fit(iris['data'], iris['target'])

print(xgb_cmodel.feature_importances_)
plot_importance(xgb_cmodel)
plt.show()

# saving to file with proper feature names
# xgbfir.saveXgbFI(xgb_cmodel, feature_names=iris.feature_names, OutputXlsxFile = '.../irisFI.xlsx')

#%%
iris.data.head()
