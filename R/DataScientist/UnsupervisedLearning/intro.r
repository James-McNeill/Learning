# Unsupervised Learning
# The k-means algorithm is one common approach to clustering.

# Create the k-means model: km.out
km.out <- kmeans(x, centers=3, nstart=20)

# Inspect the result
summary(km.out)

# Results of kmeans
# Print the cluster membership component of the model
km.out

# Print the km.out object
print(km.out)

# Scatter plot of x
plot(x, col = km.out$cluster, main = "k-means with 3 clusters", xlab = "", ylab = "")
