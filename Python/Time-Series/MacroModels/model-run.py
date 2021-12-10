# Model build and estimation

# A. Initial setup
# Import packages and modules
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time
import sys
import os
import plotly.express as px
from sklearn.linear_model import LinearRegression
from sklearn import metrics
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.sandbox.regression.predstd import wls_prediction_std
from statsmodels.stats.outliers_influence import OLSInfluence
from statsmodels.compat import lzip
import statsmodels.formula.api as smf
import statsmodels.stats.api as sms
from statsmodels.graphics.regressionplots import plot_leverage_resid2

# Print current working directory location
print(os.getcwd()+'/')
# Connect to the repo package folder to use in this Notebook
sys.path.append("/home/ec2-user/SageMaker/s3-user-bucket/.../")

# Import the sub-packages
from stmd import utils as stmd

# Formatting for the float variables
pd.options.display.float_format = '{:,.5f}'.format

# Create the pandas cursor object
pandas_cursor = stmd.create_cursor()

# Seaborn style defaults
sns.set(rc={'figure.figsize':(30,12)})
sns.set_style("darkgrid")

# Show all cell outputs requested
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"

# Warnings module. Print a warning message once.
import warnings
#warnings.simplefilter('once', category=UserWarning)
warnings.simplefilter('ignore', category=UserWarning)

# B. Dependent variable
# Import the dataset that was created using ODR Curve
df = pd.read_csv('odr.csv', index_col='month', parse_dates=True)
df.head()

# Visualisation with slider
fig = px.line(df, x=df.index, y='ODR', title='ODR with slider')
fig.update_xaxes(rangeslider_visible=True)
fig.show()

# Bring in the dependent variable transformation that is being used for this development
# CSV file = dep_var_new.csv, created in the notebook Dependent Variable
df_dep = pd.read_csv('dep_var_new.csv', index_col='month', parse_dates=True)
df_dep = df_dep.loc[:, 'ODR_X']
df_dep.head()

# C. Independent Variable
# Import the independent variable excel file
df_ind = pd.read_excel('INDEPENDENT_VARIABLES.xlsx',engine='openpyxl', index_col='Date', parse_dates=True).rename_axis('macro', axis=1)
# Adjust the month end dates to month begin dates. Allows for joining dataframes
df_ind.index = df_ind.index - pd.offsets.MonthBegin()
df_ind.head()

# Only need to keep the date values that relate to the dependent variable dataset
date_filt = np.array(df_ind.index <= '2019-12-01')
df_ind.index.max()
df_ind = df_ind[date_filt]
df_ind.index.max()

# D. All transformations
# Columns for review
df_ind.columns

# Apply the basic transformations method
df_ind1 = df_ind.copy()
stmd.transformations().basic_transformations(df_ind1, 1)
# Drop initial columns after transformation
orig_cols = list(df_ind.columns)
df_ind1.drop(columns=orig_cols, inplace=True)

# Add the lagged method to create range of transformed variables
df_ind2 = df_ind1.copy()
stmd.transformations().create_lags(df_ind2)
# Drop original columns from the final transformed list
orig_cols = list(df_ind1.columns)
df_ind2.drop(columns=orig_cols, inplace=True)

# Import the final independent variable list. Contains the variable with the transformation
df_final_ind = pd.read_excel('Final_Independent_Variables.xlsx',engine='openpyxl')
df_final_ind

# Create the list of independent variables
df_indep_list = [x for x in df_final_ind['VARIABLE']]
df_indep_list

# Datasets to use for estimation
dep = df_dep
indep = df_ind2[['var1','var2']]
indep

# Merge the dataframes together by index
mod_df = pd.merge(dep
                 ,indep
                 ,how='left'
                 ,left_index=True
                 ,right_index=True
                 )

mod_df = mod_df.loc[(mod_df['var1'].notnull()) & (mod_df.index <= '2019-12-01') & (mod_df.index >= '2009-06-01')]
# # Scale up the dependent and independent variables
mod_df['var2'] = mod_df['var2'] * 100
mod_df

# E. Linear Regression model
# Independent variables
indep_vars = ['var1', 'var2']

x = mod_df[indep_vars]
y = mod_df[['ODR_X']]

# Understand initial relationships
mod_df.plot(x='ODR_X', y='var1', style='o')
plt.title('Default rate by var1')
plt.xlabel('Def_Rate')
plt.ylabel('var1')
plt.show();

# Lets review the dispertion of the default rate
plt.figure(figsize=(10,5))
plt.tight_layout()
sns.displot(mod_df['ODR_X']);

# Run the linear regression
model = LinearRegression(fit_intercept=False) # Turn off the intercept
model.fit(x,y) # training the algorithm

mod_df['predicted'] = model.predict(x)

y_pred = mod_df[['predicted']]
mod_df.head()

# Retrieve the results
# The intercept
print(model.intercept_)
# The variable coefficients
print(model.coef_)

# Display the prediction vs actual
mod_df[['ODR_X', 'predicted']].plot(alpha=0.5);

# Display summary statistics
print('Mean Absolute Error:', metrics.mean_absolute_error(y, y_pred))  
print('Mean Squared Error:', metrics.mean_squared_error(y, y_pred))  
print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(y, y_pred)))

# Run the analysis using statsmodels. Produces more meaningful results
sm_model = sm.OLS(y, x).fit()
sm_model.summary()

#Draw a plot to compare the true relationship to OLS predictions. 
# Confidence intervals around the predictions are built using the wls_prediction_std command.
prstd, iv_l, iv_u = wls_prediction_std(sm_model)

fig, ax = plt.subplots(figsize=(8,6))

ax.plot(y, 'o', label="data")
ax.plot(sm_model.fittedvalues, 'r--.', label="OLS")
ax.plot(iv_u, 'r--', label="uCI", color='green')
ax.plot(iv_l, 'r--', label="lCI", color='purple')
ax.legend(loc='best');

# Get the influence of each data point in the regression
infl = sm_model.get_influence()
sum0 = infl.summary_frame().filter(regex="dfb")
sum1 = infl.summary_frame()
sum1.head()

# Review variable influence
plt.plot(sum0['var1'], label="var1")
plt.plot(sum0['var2'], label="var2")
plt.legend()
plt.show();

# Reviewing the student_resid
fig = px.bar(sum1, x=sum1.index, y="student_resid")
fig.show()

# Reviewing the variance inflation factors
vif = [variance_inflation_factor(x.values, i) for i in range(x.shape[1])]
vif

# Normality and auto correlation for residuals
resids = sm_model.resid
resids

#Normality of residuals

# Jarque-Bera test:
name = ['Jarque-Bera', 'Chi^2 two-tail prob.', 'Skew', 'Kurtosis']
test = sms.jarque_bera(resids)
lzip(name,test)

# Omni test:
name = ['Chi^2', 'Two-tail probability']
test = sms.omni_normtest(resids)
lzip(name, test)

# Influence tests
test_class = OLSInfluence(sm_model)
test_betas = test_class.dfbetas
# test_betas

# Information on the leverage can be reviewed
fig, ax = plt.subplots(figsize=(8,6))
fig = plot_leverage_resid2(sm_model, ax=ax)

# Multicollinearity
np.linalg.cond(sm_model.model.exog)

# Heteroskedasticity tests
name = ['Lagrange multiplier statistic', 'p-value',
        'f-value', 'f p-value']
test = sms.het_breuschpagan(sm_model.resid, sm_model.model.exog)
lzip(name, test)

name = ['F statistic', 'p-value']
test = sms.het_goldfeldquandt(sm_model.resid, sm_model.model.exog)
lzip(name, test)

# Linearity
name = ['t value', 'p value']
test = sms.linear_harvey_collier(sm_model)
lzip(name, test)
