# Bagging and Random Forests
# Bagging Out Of Bag (OOB) Evaluation

'''
Bagging is a term for bootstrap aggregation. It is a process of machine learning whereby the same algorithm is reviewed 
using N trees to provide different classifiers outputs based on bootstrapped samples of the data. The with replacement feature 
is invoked to ensure that any value can be selected multiple times within the sample set. There are bagging classifiers for 
classification and regression target variables. The classification algorithm uses the majority vote algorithm to arrive at the 
final output and the regression algorithm searches for the average value to be applied. In both instances a baseline classifier 
is instanciates and then the bagging aims to reduce the model variance and hence improve the overall fit. Remember a large variance 
between samples means that the model is overfitting the data too much

OOB is a technique used to account for the element of each bagged sample which is treated as the test set. Therefore for each 
bagged tree sample that is review a certain percentage will be used to train and another left for testing the accuracy. It is this 
OOB that can be used as well to test for the accuracy of the model on unseen data. In a classification algorithm the parameter of 
interest is called oob_score, whereas for a regression algorithm the an r-squared value is reviewed.
'''

# Import DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier

# Import BaggingClassifier
from sklearn.ensemble import BaggingClassifier

# Instantiate dt
dt = DecisionTreeClassifier(random_state=1)

# Instantiate bc
bc = BaggingClassifier(base_estimator=dt, n_estimators=50, random_state=1)

# Import DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier

# Import BaggingClassifier
from sklearn.ensemble import BaggingClassifier

# Instantiate dt
dt = DecisionTreeClassifier(min_samples_leaf=8, random_state=1)

# Instantiate bc
bc = BaggingClassifier(base_estimator=dt, 
            n_estimators=50,
            oob_score=True,
            random_state=1)
# Fit bc to the training set 
bc.fit(X_train, y_train)

# Predict test set labels
y_pred = bc.predict(X_test)

# Evaluate test set accuracy
acc_test = accuracy_score(y_test, y_pred)

# Evaluate OOB accuracy
acc_oob = bc.oob_score_

# Print acc_test and acc_oob
print('Test set accuracy: {:.3f}, OOB accuracy: {:.3f}'.format(acc_test, acc_oob))
