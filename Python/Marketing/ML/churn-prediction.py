# Churn prediction fundamentals
# Reviewing Telco data

# Explore data
# Print the unique Churn values
print(set(telcom['Churn']))

# Calculate the ratio size of each churn group
telcom.groupby(['Churn']).size() / telcom.shape[0] * 100

# Import the function for splitting data to train and test
from sklearn.model_selection import train_test_split

# Split the data into train and test
train, test = train_test_split(telcom, test_size = .25)

# Store column names from `telcom` excluding target variable and customer ID
cols = [col for col in telcom.columns if col not in custid + target]

# Extract training features
train_X = train[cols]

# Extract training target
train_Y = train[target]

# Extract testing features
test_X = test[cols]

# Extract testing target
test_Y = test[target]

# Fit logistic regression
# Fit logistic regression on training data
logreg.fit(train_X, train_Y)

# Predict churn labels on testing data
pred_test_Y = logreg.predict(test_X)

# Calculate accuracy score on testing data
test_accuracy = accuracy_score(test_Y, pred_test_Y)

# Print test accuracy score rounded to 4 decimals
print('Test accuracy:', round(test_accuracy, 4))

# Using L1 regularization (Lasso)
# Aims to reduce the number of features by reducing the co-efficients to zero. By default the L2 (ridge) regression is used by the algorithm to make
# sure that the model doesn't overfit the training data and if it did it would then perform poorly on the test data.
# Initialize logistic regression instance 
logreg = LogisticRegression(penalty='l1', C=0.025, solver='liblinear')

# Fit the model on training data
logreg.fit(train_X, train_Y)

# Predict churn values on test data
pred_test_Y = logreg.predict(test_X)

# Print the accuracy score on test data
print('Test accuracy:', round(accuracy_score(test_Y, pred_test_Y), 4))

# Identify optimal L1 penalty coefficient
# Aim is to select the model with the number of features that have not reduced the overall recall too much when compared to including all features
# Run a for loop over the range of C list length
for index in range(0, len(C)):
  # Initialize and fit Logistic Regression with the C candidate
  logreg = LogisticRegression(penalty='l1', C=C[index], solver='liblinear')
  logreg.fit(train_X, train_Y)
  # Predict churn on the testing data
  pred_test_Y = logreg.predict(test_X)
  # Create non-zero count and recall score columns
  l1_metrics[index,1] = np.count_nonzero(logreg.coef_)
  l1_metrics[index,2] = recall_score(test_Y, pred_test_Y)

# Name the columns and print the array as pandas DataFrame
col_names = ['C','Non-Zero Coeffs','Recall']
print(pd.DataFrame(l1_metrics, columns=col_names))

# Decision tree
# Initialize decision tree classifier
mytree = tree.DecisionTreeClassifier()

# Fit the decision tree on training data
mytree.fit(train_X, train_Y)

# Predict churn labels on testing data
pred_test_Y = mytree.predict(test_X)

# Calculate accuracy score on testing data
test_accuracy = accuracy_score(test_Y, pred_test_Y)

# Print test accuracy
print('Test accuracy:', round(test_accuracy, 4))

# Identify optimal tree depth
# Run a for loop over the range of depth list length
for index in range(0, len(depth_list)):
  # Initialize and fit decision tree with the `max_depth` candidate
  mytree = DecisionTreeClassifier(max_depth=depth_list[index])
  mytree.fit(train_X, train_Y)
  # Predict churn on the testing data
  pred_test_Y = mytree.predict(test_X)
  # Calculate the recall score 
  depth_tuning[index,1] = recall_score(test_Y, pred_test_Y)

# Name the columns and print the array as pandas DataFrame
col_names = ['Max_Depth','Recall']
print(pd.DataFrame(depth_tuning, columns=col_names))
