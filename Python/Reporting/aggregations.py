# Apply the mappings
df.groupby(['var_x', 'var_y'], dropna=False).agg({
        'ID': ['count'],
        'summary_var_y': lambda x: x.isna().sum()
    })

# Reviewing the cases with null summary_var_y when DataFrames joined together
df1 = (
    df
    .loc[df.summary_var_y.isnull()]
)
df1.shape
df1.head()
