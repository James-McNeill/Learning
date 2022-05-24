# Pearson Correlation Analysis (PCA)

'''
PCA helps to decorrelate the data. Aiming to bring all data points within a variable to have a mean of zero. Therefore all 
of the variable values will be mapped around (0,0) corrdinates in the graph but still maintain their actual point differences relative to each other
Recall that the principal components are the directions along which the the data varies.

The first principal component of the data is the direction in which the data varies the most. In this exercise, your job is to use PCA to find the 
first principal component of the length and width measurements of the grain samples, and represent it as an arrow on the scatter plot.
'''

from scipy.stats import pearsonr
# Calculate the Pearson correlation
correlation, pvalue = pearsonr(width, length)
# Import PCA
from sklearn.decomposition import PCA

# Create PCA instance: model
model = PCA()

# Apply the fit_transform method of model to grains: pca_features
pca_features = model.fit_transform(grains)
# Make a scatter plot of the untransformed points
plt.scatter(grains[:,0], grains[:,1])

# Create a PCA instance: model
model = PCA()

# Fit model to points
model.fit(grains)

# Get the mean of the grain samples: mean
mean = model.mean_

# Get the first principal component: first_pc
first_pc = model.components_[0,:]

# Plot first_pc as an arrow, starting at mean
plt.arrow(mean[0], mean[1], first_pc[0], first_pc[1], color='red', width=0.01)

# Keep axes on same scale
plt.axis('equal')
plt.show()
# Perform the necessary imports
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
import matplotlib.pyplot as plt

# Create scaler: scaler
scaler = StandardScaler()

# Create a PCA instance: pca
pca = PCA()

# Create pipeline: pipeline
pipeline = make_pipeline(scaler, pca)

# Fit the pipeline to 'samples'
pipeline.fit(samples)

# Plot the explained variances
features = range(pca.n_components_)
plt.bar(features, pca.explained_variance_)
plt.xlabel('PCA feature')
plt.ylabel('variance')
plt.xticks(features)
plt.show()
