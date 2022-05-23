# Boosting

'''
Introduced to the AdaBoost (Adaptive Boosting) classifiers and regressor algorithms. They aim to learn from the previous models that 
were built to reduce the errors. So were there were large residuals from the first model predictions then the next model estimation concentrates 
on these values instead of the already optimised values. This method continues n-times.

Gradient boosting is the next step in the booster algorithms. Similar to the adaboost we have to be mindful of the theta value that is aplied 
when the algorithm aims to learn with each model build. There is a feature called shrinkage which aims to target the residual value of the previous
model estimate and minimise the residual errors of the current model. All of the models estimated are combined at the end to create the final predicted labels

Stochastic gradient boosting works as a continuation of the gradient boosting algorithm. In order to enforce the randomness asociated with a 
stochastic process, two additional features are used within the gradient boosting algorithm. These aim to ensure that the training dataset for 
each ensemble model takes a certain proportion of the sample as well as ensuring that a certain proportion of the features are being used within 
each tree. In turn this helps to spread the number of features to understand better which range can be used. Whereas the gradient boosting algorithm 
aimed to take the initial features and optimise there importance when predicting the model estimates
'''

# Import DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier

# Import AdaBoostClassifier
from sklearn.ensemble import AdaBoostClassifier

# Instantiate dt
dt = DecisionTreeClassifier(max_depth=2, random_state=1)

# Instantiate ada
ada = AdaBoostClassifier(base_estimator=dt, n_estimators=180, random_state=1)
# Fit ada to the training set
ada.fit(X_train, y_train)

# Compute the probabilities of obtaining the positive class
y_pred_proba = ada.predict_proba(X_test)[:,1]
# Import roc_auc_score
from sklearn.metrics import roc_auc_score

# Evaluate test-set roc_auc_score
ada_roc_auc = roc_auc_score(y_test, y_pred_proba)

# Print roc_auc_score
print('ROC AUC score: {:.2f}'.format(ada_roc_auc))

# Import GradientBoostingRegressor
from sklearn.ensemble import GradientBoostingRegressor

# Instantiate gb
gb = GradientBoostingRegressor(max_depth=4, 
            n_estimators=200,
            random_state=2)
# Fit gb to the training set
gb.fit(X_train, y_train)

# Predict test set labels
y_pred = gb.predict(X_test)
# Import mean_squared_error as MSE
from sklearn.metrics import mean_squared_error as MSE

# Compute MSE
mse_test = MSE(y_test, y_pred)

# Compute RMSE
rmse_test = mse_test**(1/2)

# Print RMSE
print('Test set RMSE of gb: {:.3f}'.format(rmse_test))
# Import GradientBoostingRegressor
from sklearn.ensemble import GradientBoostingRegressor

# Instantiate sgbr
sgbr = GradientBoostingRegressor(max_depth=4, 
            subsample=0.9, # Percent of training sample
            max_features=0.75, # Percent of features to use
            n_estimators=200, # Number of trees 
            random_state=2)
# Fit sgbr to the training set
sgbr.fit(X_train, y_train)

# Predict test set labels
y_pred = sgbr.predict(X_test)
# Import mean_squared_error as MSE
from sklearn.metrics import mean_squared_error as MSE

# Compute test set MSE
mse_test = MSE(y_test, y_pred)

# Compute test set RMSE
rmse_test = mse_test ** (1/2)

# Print rmse_test
print('Test set RMSE of sgbr: {:.3f}'.format(rmse_test))
