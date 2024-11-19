def percentile_series(x, p=0.95):
    return np.percentile(x, p)

diff_check.groupby('variable_reviewed').agg({
   'variable': ['count','min', 'mean', 'max','median', pd.Series.mode, 'nunique', percentile_series]
})
