# Hierarchical Clustering

# Create hierarchical clustering model: hclust.out. dist() is a matrix for euclidean distance between points
hclust.out <- hclust(dist(x))

# Inspect the result
summary(hclust.out)

# Dendrogram. Used to visualize the process of clustering datapoints
plot(hclust.out)

# Draw a line to cut by height on the plot
abline(h = 6, col = "red")

# Cutting the tree to return group values per row of the dataset
# Cut by height
cutree(hclust.out, h = 7)

# Cut by number of clusters
cutree(hclust.out, k = 3)
