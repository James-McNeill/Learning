# Set up the LabelEncoder object
enc = LabelEncoder()

# Apply the encoding to the "Accessible" column - produces a binary numeric output
hiking["Accessible_enc"] = enc.fit_transform(hiking["Accessible"])

# Compare the two columns
print(hiking[["Accessible", "Accessible_enc"]].head())

# Transform the category_desc column into dummy category features for each category
category_enc = pd.get_dummies(volunteer["category_desc"])

# Take a look at the encoded columns
print(category_enc.head())
