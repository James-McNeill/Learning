# Converting categorical features into encoding features
# Be aware that including information the same information that can be inferred with multiple features
# will create co-linearity within the model, so care must be taken. For example, creating two dummy variables
# for a binary categorical feature

# One hot encoding
# Convert the Country column to a one hot encoded Data Frame
one_hot_encoded = pd.get_dummies(so_survey_df, columns=['Country'], prefix='OH')

# Print the columns names
print(one_hot_encoded.columns)

# Dummy variables
# Create dummy variables for the Country column
dummy = pd.get_dummies(so_survey_df, columns=['Country'], drop_first=True, prefix='DM')

# Print the columns names
print(dummy.columns)
