# Data manipulation using .groupby()

# A. Data transformation using .groupby().transform
# 1. The min-max normalization using .transform()
# Define the min-max transformation
min_max_tr = lambda x: (x - x.min()) / (x.max() - x.min())

# Group the data according to the time
restaurant_grouped = restaurant_data.groupby('time')

# Apply the transformation
restaurant_min_max_group = restaurant_grouped.transform(min_max_tr)
print(restaurant_min_max_group.head())

# 2. Transforming values to probabilities
# Define the exponential transformation
exp_tr = lambda x: np.exp(-x.mean() * x) * x.mean()

# Group the data according to the time
restaurant_grouped = restaurant_data.groupby('time')

# Apply the transformation
restaurant_exp_group = restaurant_grouped['tip'].transform(exp_tr)
print(restaurant_exp_group.head())

# 3. Validation of normalization
zscore = lambda x: (x - x.mean()) / x.std()

# Apply the transformation
poker_trans = poker_grouped.transform(zscore)

# Re-group the grouped object and print each group's means and standard deviation
poker_regrouped = poker_trans.groupby(poker_hands['Class'])

print(np.round(poker_regrouped.mean(), 3))
print(poker_regrouped.std())

# B. Missing value imputation using transform()
# 1. Identifying missing values
# Group both objects according to smoke condition
restaurant_nan_grouped = restaurant_nan.groupby('smoker')

# Store the number of present values
restaurant_nan_nval = restaurant_nan_grouped['tip'].count()

# Print the group-wise missing entries
print(restaurant_nan_grouped['total_bill'].count() - restaurant_nan_nval)

# 2. Missing value imputation
# Define the lambda function
missing_trans = lambda x: x.fillna(x.median())

# Group the data according to time
restaurant_grouped = restaurant_data.groupby('time')

# Apply the transformation
restaurant_impute = restaurant_grouped.transform(missing_trans)
print(restaurant_impute.head())

