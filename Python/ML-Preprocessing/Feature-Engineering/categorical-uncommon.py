# Dealing with uncommon categories
# Understanding features with larger cardinality. Aiming to group categories with
# lower frequency values into a catch all category

# Create a series out of the Country column
countries = so_survey_df['Country']

# Get the counts of each category
country_counts = countries.value_counts()

# Create a mask for only categories that occur less than 10 times
mask = countries.isin(country_counts[country_counts < 10].index)

# Label all other categories as Other
so_survey_df['Country'][mask] = 'Other'

# Print the updated category counts
print(pd.value_counts(so_survey_df['Country']))
