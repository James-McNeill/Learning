# Customer Lifetime Value (CLV) basics

# Build retention and churn tables
# Extract cohort sizes from the first column of cohort_counts
cohort_sizes = cohort_counts.iloc[:,0]

# Calculate retention by dividing the counts with the cohort sizes
retention = cohort_counts.divide(cohort_sizes, axis=0)

# Calculate churn
churn = 1 - retention

# Print the retention table
print(retention)

# Explore rentention and churn
# Calculate the mean retention rate. Having two means in combination is called "chaining" and will calculate the overall mean
retention_rate = retention.iloc[:,1:].mean().mean()

# Calculate the mean churn rate
churn_rate = churn.iloc[:,1:].mean().mean()

# Print rounded retention and churn rates
print('Retention rate: {:.2f}; Churn rate: {:.2f}'.format(retention_rate, churn_rate))
