# Working the clean the text
# The method .isalpha() can really help with cleaning. However it can remove text such as U.S.A or U.K due to the period
# being included within the text. A custom method could be created to ensure that important text is not removed.

# Load model and create Doc object
nlp = spacy.load('en_core_web_sm')
doc = nlp(blog)

# Generate lemmatized tokens
lemmas = [token.lemma_ for token in doc]

# Remove stopwords and non-alphabetic tokens
a_lemmas = [lemma for lemma in lemmas 
            if lemma.isalpha() and lemma not in stopwords]

# Print string after text cleaning
print(' '.join(a_lemmas))
