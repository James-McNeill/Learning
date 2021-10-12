# Data Leakage occurs when unseen test data is provided to the scaling transformater. Such a process would not
# happen in the wild as new unforseen data would not be available during the model development. Therefore, during
# model calibration (training stage) this unseen test data should be left out

# 1. Scaling
# Import StandardScaler
from sklearn.preprocessing import StandardScaler

# Apply a standard scaler to the data
SS_scaler = StandardScaler()

# Fit the standard scaler to the data
SS_scaler.fit(so_train_numeric[['Age']])

# Transform the test data using the fitted scaler
so_test_numeric['Age_ss'] = SS_scaler.transform(so_test_numeric[['Age']])
print(so_test_numeric[['Age', 'Age_ss']].head())

# 2. Removal of outliers process steps
train_std = so_train_numeric['ConvertedSalary'].std()
train_mean = so_train_numeric['ConvertedSalary'].mean()

cut_off = train_std * 3
train_lower, train_upper = train_mean - cut_off, train_mean + cut_off

# Trim the test DataFrame
trimmed_df = so_test_numeric[(so_test_numeric['ConvertedSalary'] < train_upper)
                             & (so_test_numeric['ConvertedSalary'] > train_lower)]
