# -*- coding: utf-8 -*-
"""
Created on Thu May 11 14:28:23 2023

@author: jamesmcneill
"""
#%%
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import numpy as np

# Import csv file for the list of questions
database_qs = pd.read_csv(".../QuestionsRepo.csv", encoding="ISO-8859-1")
#%% Create a function
def question_database(df_: pd.DataFrame = database_qs, user_question: str = "Data Quality", col_name: str = "Questions"):
    text_database = [x for x in df_.loc[:, col_name] if pd.notnull(x)]

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
        print(f"Similarity: {score:.5f}\tText: {text}")

    # Create a data frame
    return pd.DataFrame(data = results, columns = {"score", "text"})

# Run the function with key question
results_df = question_database(user_question="Concentration risk")

# Using the code to review addresses
address_data = pd.read_csv(".../GeoDirectorySampleData.csv", encoding="ISO-8859-1")

# Run the function with key question
results_df = question_database(df_ = address_data, user_question = "amberlea", col_name = "ADDR_LINE_1")
