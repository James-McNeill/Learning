# N-grams relate to the sequence of words that are reviewed to better understand the context from the text.
# By only keeping a bag of words, phrase for only reviewing single words, this removes the message that was
# created within the text. To maintain the message this is where n-grams of different lengths can be used.
# bigrams: Sequences of two consecutive words
# trigrams: Sequences of two consecutive words
# Overall aim is trying to review the sentement of the text (positive / neutral / negative)

# Import CountVectorizer
from sklearn.feature_extraction.text import CountVectorizer

# Instantiate a trigram vectorizer
cv_trigram_vec = CountVectorizer(max_features=100, 
                                 stop_words='english', 
                                 ngram_range=(3, 3))

# Fit and apply trigram vectorizer
cv_trigram = cv_trigram_vec.fit_transform(speech_df['text_clean'])

# Print the trigram features
print(cv_trigram_vec.get_feature_names())
