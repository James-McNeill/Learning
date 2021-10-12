# Working with the CountVectorizer

# Import CountVectorizer
from sklearn.feature_extraction.text import CountVectorizer

# Instantiate CountVectorizer
cv = CountVectorizer()

# Fit the vectorizer
cv.fit(speech_df['text_clean'])

# Print feature names - shows words in alphabetical order
print(cv.get_feature_names())

# Apply the vectorizer
cv_transformed = cv.transform(speech_df['text_clean'])

# Print the full array
cv_array = cv_transformed.toarray()

# Print the shape of cv_array
print(cv_array.shape)

# Reducing the number of words that are being retained based on keyword params
# min_df: Use only words that occur in more than this percentage of documents. 
#         This can be used to remove outlier words that will not generalize across texts.
# max_df: Use only words that occur in less than this percentage of documents. 
#         This is useful to eliminate very common words that occur in every corpus without adding value such as "and" or "the"

# Import CountVectorizer
from sklearn.feature_extraction.text import CountVectorizer

# Specify arguements to limit the number of features generated
cv = CountVectorizer(min_df=0.20, max_df=0.80)

# Fit, transform, and convert into array
cv_transformed = cv.fit_transform(speech_df['text_clean'])
cv_array = cv_transformed.toarray()

# Print the array shape
print(cv_array.shape)
