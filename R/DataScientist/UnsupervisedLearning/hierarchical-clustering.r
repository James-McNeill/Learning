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

# Linkage methods
# Cluster using complete linkage: hclust.complete
hclust.complete <- hclust(dist(x), method = "complete")

# Cluster using average linkage: hclust.average
hclust.average <- hclust(dist(x), method = "average")

# Cluster using single linkage: hclust.single
hclust.single <- hclust(dist(x), method = "single")

# Plot dendrogram of hclust.complete
plot(hclust.complete, main = "Complete")

# Plot dendrogram of hclust.average
plot(hclust.average, main = "Average")

# Plot dendrogram of hclust.single
plot(hclust.single, main = "Single")

# Scaling
# Due to the features having different scales (mean & sd) the columns had to be rescaled
# View column means
colMeans(pokemon)

# View column standard deviations
apply(pokemon, 2, sd)

# Scale the data
pokemon.scaled <- scale(pokemon)
# colMeans(pokemon.scaled)
# apply(pokemon.scaled, 2, sd)

# Create hierarchical clustering model: hclust.pokemon
hclust.pokemon <- hclust(dist(pokemon.scaled), method = "complete")

# Comparing kmeans() and hclust()
# Apply cutree() to hclust.pokemon: cut.pokemon
cut.pokemon <- cutree(hclust.pokemon, k = 3)

# Compare methods
# The hclust() assigns the majority of data points to the first cluster. Whereas, kmeans() produced a similar number of data points by cluster.
# Both methods work well, it all depends what the goal of the analysis is when deciding which cluster results to use.
table(km.pokemon$cluster, cut.pokemon)
