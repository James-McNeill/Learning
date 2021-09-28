# Multiple methods to standardize numeric variables. Ensures that each variable can be compared on a similar scale. 
# Features that are reviewed the most contain large population variance values.

# Log normalization
# Print out the variance of the Proline column
print(wine["Proline"].var())

# Apply the log normalization function to the Proline column
wine["Proline_log"] = np.log(wine["Proline"])

# Check the variance of the normalized Proline column
print(wine["Proline_log"].var())
