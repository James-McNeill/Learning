# Model Tuning

'''
All of the baseline models that are available are only setup with the basic parameter settings. In order to improve the accuracy
of model predictions we have to tune the models using HyperParameter tuning. In this method there are multiple options to perform 
the search algorithm. Understanding the number of observations and features to review is important as some search algorithms can take 
a long time to tune if the model dataset is very large. There are also multiple options available to extract the best params and score values. 
In order to perform the analysis a params dictionary can be created which allows for the searching to take place.
'''

# Display the default parameters of an algorithm
dt.get_params()
# shows the param values available and what can be tuned

# Import GridSearchCV
from sklearn.model_selection import GridSearchCV

# Instantiate grid_dt
grid_dt = GridSearchCV(estimator=dt,
                       param_grid=params_dt,
                       scoring='roc_auc',
                       cv=5,
                       n_jobs=-1)
# Import roc_auc_score from sklearn.metrics
from sklearn.metrics import roc_auc_score

# Extract the best estimator
best_model = grid_dt.best_estimator_

# Predict the test set probabilities of the positive class
y_pred_proba = grid_dt.predict_proba(X_test)[:,1]

# Compute test_roc_auc
test_roc_auc = roc_auc_score(y_test, y_pred_proba)

# Print test_roc_auc
print('Test set ROC AUC score: {:.3f}'.format(test_roc_auc))
# Import mean_squared_error from sklearn.metrics as MSE 
from sklearn.metrics import mean_squared_error as MSE

# Extract the best estimator
best_model = grid_rf.best_estimator_

# Predict test set labels
y_pred = best_model.predict(X_test)

# Compute rmse_test
rmse_test = MSE(y_test, y_pred) ** (1/2)

# Print rmse_test
print('Test RMSE of best model: {:.3f}'.format(rmse_test)) 
