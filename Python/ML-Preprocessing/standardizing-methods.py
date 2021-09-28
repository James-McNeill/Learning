# Multiple methods to standardize numeric variables. Ensures that each variable can be compared on a similar scale. 
# Features that are reviewed the most contain large population variance values.

# Log normalization
# Print out the variance of the Proline column
print(wine["Proline"].var())

# Apply the log normalization function to the Proline column
wine["Proline_log"] = np.log(wine["Proline"])

# Check the variance of the normalized Proline column
print(wine["Proline_log"].var())

# StandardScaler
# Import StandardScaler from scikit-learn
from sklearn.preprocessing import StandardScaler

# Create the scaler
ss = StandardScaler()

# Take a subset of the DataFrame you want to scale 
wine_subset = wine[["Ash", "Alcalinity of ash", "Magnesium"]]

# Apply the scaler to the DataFrame subset - using the method fit_transform will fit and transform the data in one step.
wine_subset_scaled = ss.fit_transform(wine_subset)
