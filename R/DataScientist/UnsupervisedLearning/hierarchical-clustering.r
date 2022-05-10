# Hierarchical Clustering

# Create hierarchical clustering model: hclust.out. dist() is a matrix for euclidean distance between points
hclust.out <- hclust(dist(x))

# Inspect the result
summary(hclust.out)
