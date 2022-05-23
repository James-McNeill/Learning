# Random Forests

'''
These Tree's build on the ideas met with single tree and bagging classifiers. There are two algorithms, one for classification 
(RandomForestClassifier) and one for regression (RandomForestRegressor). They aim to produce ensemble models using the same 
methodology but they make sure to prioritise the top features in the dataset and optimise the models using these features. 
Therefore if a sample has 100 features they will take the square root of 10 features to optimise the models on. The bootstrapped 
samples used all of the sample data points with replacement so every data point can be used.

In order to assess the improvement in model performance we can use a single tree (CART) to highlight the baseline values. Then 
the model uplift due to the RF model can be highlighted more efficiently

Final piece of code helps to highlight variable importance within the RF predictions
'''

# Import RandomForestRegressor
from sklearn.ensemble import RandomForestRegressor

# Instantiate rf
rf = RandomForestRegressor(n_estimators=25,
            random_state=2)
            
# Fit rf to the training set    
rf.fit(X_train, y_train) 
# Import mean_squared_error as MSE
from sklearn.metrics import mean_squared_error as MSE

# Predict the test set labels
y_pred = rf.predict(X_test)

# Evaluate the test set RMSE
rmse_test = MSE(y_test, y_pred)**(1/2)

# Print rmse_test
print('Test set RMSE of rf: {:.2f}'.format(rmse_test))
# Create a pd.Series of features importances
importances = pd.Series(data=rf.feature_importances_,
                        index= X_train.columns)

# Sort importances
importances_sorted = importances.sort_values()

# Draw a horizontal barplot of importances_sorted
importances_sorted.plot(kind='barh', color='lightgreen')
plt.title('Features Importances')
plt.show()
