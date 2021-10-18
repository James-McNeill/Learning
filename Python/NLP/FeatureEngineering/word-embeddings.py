# Word embeddings can be used to create n-vector dimensional spaces that have similar meanings
# Spacy is a great package for this as word embeddings are built in

# Create the doc object
doc = nlp(sent)

# Compute pairwise similarity scores
for token1 in doc:
  for token2 in doc:
    print(token1.text, token2.text, token1.similarity(token2))

# Similarity scores for pink floyd songs. The songs on the same albums have been correctly flagged as similar as the same author composes the lyrics.
# Whereas comparing two songs from different albums showed that a lower similarity score was present
# Create Doc objects
mother_doc = nlp(mother)
hopes_doc = nlp(hopes)
hey_doc = nlp(hey)

# Print similarity between mother and hopes
print(mother_doc.similarity(hopes_doc))

# Print similarity between mother and hey
print(mother_doc.similarity(hey_doc))
