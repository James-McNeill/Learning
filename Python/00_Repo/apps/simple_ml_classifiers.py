# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from pandas.plotting import scatter_matrix

from sklearn import model_selection
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC

#%% Import the data
df = pd.read_csv('input_file.CSV', delimiter=(";"))


#%% Sample of the data
print(df.head())

#%% Review cardinality
print(df.nunique())

#%% Summarize the data
print(df.dtypes)
print(df.describe().transpose())
print(df.shape)

#%% Class distribution
print(df.groupby('S_DEF_STATUS').size())

df['TARGET'] = np.where(df.S_DEF_STATUS == 'DEF', 1, 0)

print(df.groupby(['S_DEF_STATUS', 'TARGET']).size())

#%% Plots
df1 = df.copy()
df1 = df1.select_dtypes(exclude=['object'])

for column in df1:
    df1[column].plot(kind='box', subplots=True, sharex=False, sharey=False)
    plt.show()

#%% Histograms
for column in df1:
    df1[column].hist()
    plt.show()
    
#%% Scatter matrix
# scatter_matrix(df1)
# plt.show()

#%% Evaluate algorithms
# Split out the dataset
features = ['B_RESMAT','B_PROD','E_ONBAL','E_OFFBAL','D_DPD','P_PROVF','R_INTRAT_T0','R_INTRAT_TH']
X = df.loc[:, features]
Y = df.TARGET

# add dummies
X = pd.get_dummies(X, drop_first=True)

#%%
X_train, X_test, Y_train, Y_test = model_selection.train_test_split(X, Y, test_size=0.3, random_state=7)

#%% Test options and evaluation metric
scoring = 'accuracy'

# Spot check algorithms
models = []
models.append(('LR', LogisticRegression()))
models.append(('LDA', LinearDiscriminantAnalysis()))
models.append(('KNN', KNeighborsClassifier()))
models.append(('CART', DecisionTreeClassifier()))
models.append(('NB', GaussianNB()))
models.append(('SVM', SVC()))

#%% evaluate each model in turn
results = []
names = []
for name, model in models:
    kfold = model_selection.KFold(n_splits=10, random_state=7, shuffle=True)
    cv_results = model_selection.cross_val_score(model, X_train, Y_train, cv=kfold, scoring=scoring)
    results.append(cv_results)
    names.append(name)
    msg = "%s: %f (%f)" % (name, cv_results.mean(), cv_results.std())
    print(msg)

#%% Compare algorithms
fig = plt.figure()
fig.suptitle('Algorithm Comparison')
ax = fig.add_subplot(111)
plt.boxplot(results)
ax.set_xticklabels(names)
plt.show()

#%% Make predictions on validation dataset
knn = KNeighborsClassifier()
knn.fit(X_train, Y_train)
predictions = knn.predict(X_test)
print(accuracy_score(Y_test, predictions))
print(confusion_matrix(Y_test, predictions))
print(classification_report(Y_test, predictions))

#%% Feature importance
model = LogisticRegression()
model.fit(X_train, Y_train)
# get importance
importance = model.coef_[0]
coef_dict = {}
# summarize feature importance
for coef, feat in zip(importance, X.columns):
    coef_dict[feat] = coef
    print(f'Feature {feat}, score: {coef}')

print(coef_dict)

#%% plot feature importance
plt.bar(range(len(coef_dict)), list(coef_dict.values()), tick_label=list(coef_dict.keys()))
plt.xticks(rotation=90)
plt.show()
