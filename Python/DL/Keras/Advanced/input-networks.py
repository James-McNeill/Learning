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

# 2. Define team model
# The team strength lookup has three components: an input, an embedding layer, and a flatten layer that creates the output
# Imports
from keras.layers import Input, Embedding, Flatten
from keras.models import Model

# Create an input layer for the team ID
teamid_in = Input(shape=(1,))

# Lookup the input in the team strength embedding layer
strength_lookup = team_lookup(teamid_in)

# Flatten the output
strength_lookup_flat = Flatten()(strength_lookup)

# Combine the operations into a single, re-usable model
team_strength_model = Model(teamid_in, strength_lookup_flat, name='Team-Strength-Model')

# B. Shared layers
# 1. Defining two inputs
# Load the input layer from keras.layers
from keras.layers import Input

# Input layer for team 1. Providing a name makes it easier to visualize the elements of the model
team_in_1 = Input(shape=(1,), name="Team-1-In")

# Separate input layer for team 2
team_in_2 = Input(shape=(1,), name="Team-2-In")

# 2. Lookup both inputs in the same model
# You want to learn a strength rating for each team, such that if any pair of teams plays each other, 
# you can predict the score, even if those two teams have never played before. 
# Furthermore, you want the strength rating to be the same, regardless of whether the team is the home team or the away team
# Lookup team 1 in the team strength model
team_1_strength = team_strength_model(team_in_1)

# Lookup team 2 in the team strength model
team_2_strength = team_strength_model(team_in_2)

# C. Merge layers
# 1. Output layer using shared layer
# Import the Subtract layer from keras
from keras.layers import Subtract

# Create a subtract layer using the inputs from the previous exercise. Subtracts the team strength rating to determine a winner
score_diff = Subtract()([team_1_strength, team_2_strength])

# 2. Model using two inputs and one output
# Imports
from keras.layers import Subtract
from keras.models import Model

# Subtraction layer from previous exercise
score_diff = Subtract()([team_1_strength, team_2_strength])

# Create the model
model = Model([team_in_1, team_in_2], score_diff)

# Compile the model
model.compile(optimizer="adam", loss="mean_absolute_error")

# D. Predict from the model
# 1. Fit the model to the regular season data
# Get the team_1 column from the regular season data
input_1 = games_season["team_1"]

# Get the team_2 column from the regular season data
input_2 = games_season["team_2"]

# Fit the model to input 1 and 2, using score diff as a target. Model has learned a strength rating for each team
model.fit([input_1, input_2],
          games_season["score_diff"],
          epochs=1,
          batch_size=2048,
          validation_split=0.10,
          verbose=True)

# 2. Evaluate the model on the tournament test data
# Interesting to see how well the model fits when some teams don't play each other during the regular season. Will see if the model overfits
# Get team_1 from the tournament data
input_1 = games_tourney["team_1"]

# Get team_2 from the tournament data
input_2 = games_tourney["team_2"]

# Evaluate the model using these inputs
print(model.evaluate([input_1, input_2], games_tourney["score_diff"], verbose=False))
