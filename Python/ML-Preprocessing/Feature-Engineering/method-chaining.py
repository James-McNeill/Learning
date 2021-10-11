# Use method chaining - can perform multiple methods on the same feature
so_survey_df['RawSalary'] = so_survey_df['RawSalary']\
                              .str.replace(',', '')\
                              .str.replace('$', '')\
                              .str.replace('£', '')\
                              .astype(float)
 
# Print the RawSalary column
print(so_survey_df['RawSalary'])
