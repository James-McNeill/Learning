# Input networks

# A. Category embeddings
# 1. Define team lookup
# The embedding layer is a lot like a dictionary, but your model learns the values for each key
# Imports
from keras.layers import Embedding
from numpy import unique

# Count the unique number of teams
n_teams = unique(games_season["team_1"]).shape[0]

# Create an embedding layer
team_lookup = Embedding(input_dim=n_teams,
                        output_dim=1, # creating 1 output value by team
                        input_length=1, # each team is represented by a unique id in the dataset for each game that took place
                        name='Team-Strength')
