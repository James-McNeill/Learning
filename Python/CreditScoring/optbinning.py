# Working with Optbinning

'''
Optbinning websites
1. https://pypi.org/project/optbinning/
2. http://gnpalencia.org/optbinning/
'''

from optbinning import OptimalBinning

# Future work - https://towardsdatascience.com/developing-scorecards-in-python-using-optbinning-ab9a205e1f69
# http://gnpalencia.org/optbinning/tutorials/tutorial_binary.html
from sklearn.datasets import load_breast_cancer

# Import data
data = load_breast_cancer()

# Load data into a DataFrame
df = pd.DataFrame(data.data, columns=data.feature_names)
df.head()

# Test run with one initial variable and the target variable
variable = "mean radius"
x = df[variable].values
y = data.target

optb = OptimalBinning(name=variable, dtype="numerical", solver="cp")
optb.fit(x, y)
optb.status

# Summary of the bin split values being used
optb.splits

# Review the binning table
binning_table = optb.binning_table

# Type of variable
type(binning_table)
# optbinning.binning.binning_statistics.BinningTable

# Summary table of Bins with: EventRate, WoE, IV & JS values
binning_table.build()

# Displays plots from the binning table data
binning_table.plot(metric="woe")
binning_table.plot(metric="event_rate")

# Transformations
x_transform_woe = optb.transform(x, metric="woe")
pd.Series(x_transform_woe).value_counts()

# Transform Bins
x_transform_bins = optb.transform(x, metric="bins")
pd.Series(x_transform_bins).value_counts()

# Binning table statistical analysis
binning_table.analysis(pvalue_test="chi2")
