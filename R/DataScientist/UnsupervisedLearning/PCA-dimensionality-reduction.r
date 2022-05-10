# Dimensionality reduction with PCA

# Principal component analysis, or PCA, is a common approach to dimensionality reduction. Learn exactly what PCA does, 
# visualize the results of PCA with biplots and scree plots, and deal with practical issues such as centering and scaling the data before performing PCA

# Perform scaled PCA: pr.out
pr.out <- prcomp(x = pokemon, scale = TRUE, center = TRUE)

# Inspect model output. Aim is to reduce the number of dimensions into the fewest number of principle components but maintaining the most amount of variance.
# The PC's shows how the cumulative variance is explained with each additional component
summary(pr.out)

# PCA models in R produce additional diagnostic and output components:

# center: the column means used to center to the data, or FALSE if the data weren't centered
# scale: the column standard deviations used to scale the data, or FALSE if the data weren't scaled
# rotation: the directions of the principal component vectors in terms of the original features/variables. This information allows you to define new data 
#   in terms of the original principal components
# x: the value of each observation in the original dataset projected to the principal components
# You can access these the same as other model components. For example, use pr.out$rotation to access the rotation component.
