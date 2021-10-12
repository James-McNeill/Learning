# Working with Outliers. Reviewing methods to understand how outliers can be excluded from the data points.
# Excluding the largest or lowest values helps to improve model performance as extreme values can skew the
# model estimates

# 1. Percentage based outlier removal
# Find the 95th quantile
quantile = so_numeric_df['ConvertedSalary'].quantile(0.95)

# Trim the outliers
trimmed_df = so_numeric_df[so_numeric_df['ConvertedSalary'] < quantile]

# The original histogram
so_numeric_df[['ConvertedSalary']].hist()
plt.show()
plt.clf()

# The trimmed histogram
trimmed_df[['ConvertedSalary']].hist()
plt.show()
