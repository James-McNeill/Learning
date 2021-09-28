# A number of options exist when aiming to review how many components to include to reduce the dimensionality complexity
# Let PCA select 90% of the variance
pipe = Pipeline([('scaler', StandardScaler()),
        		 ('reducer', PCA(n_components=0.9))]) # By providing a percent ratio value this means the algorithm aims to explain this proportion of cumulative variance

# Fit the pipe to the data
pipe.fit(ansur_df)

print('{} components selected'.format(len(pipe.steps[1][1].components_)))
