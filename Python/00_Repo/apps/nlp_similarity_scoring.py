# -*- coding: utf-8 -*-
"""
Created on Thu May 11 09:02:24 2023

@author: jamesmcneill
"""

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd

# Preprocessing and vectorization
user_question = "What are the benefits of exercise?"
text_database = ["Regular exercise has numerous health benefits.",
                 "Exercise improves cardiovascular health.",
                 "The benefits of physical activity include weight loss."]

vectorizer = TfidfVectorizer()
vectors = vectorizer.fit_transform([user_question] + text_database)
user_vector = vectors[0]
database_vectors = vectors[1:]

# Similarity calculation
similarity_scores = cosine_similarity(user_vector, database_vectors)

# Ranking and retrieval
results = [(score, text) for score, text in zip(similarity_scores[0], text_database)]
results = sorted(results, key=lambda x: x[0], reverse=True)

for score, text in results:
    print(f"Similarity: {score:.2f}\tText: {text}")

# Create a data frame
results_df = pd.DataFrame(data = results, columns = {"score", "text"})

# Next steps
# Convert to functions
# Apply as a class for OOP
# Can the top N be retreived from a larger dataset?
