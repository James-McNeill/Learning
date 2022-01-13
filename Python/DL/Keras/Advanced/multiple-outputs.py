# Creating multiple outputs from model

# A. Two output models
# 1. Simple two output model
# The output from your model will be the predicted score for team 1 as well as team 2. This is called "multiple target regression": one model making more than one prediction
# Define the input
input_tensor = Input((2,))

# Define the output
output_tensor = Dense(2)(input_tensor)

# Create a model
model = Model(input_tensor, output_tensor)

# Compile the model
model.compile(optimizer="adam", loss="mean_absolute_error")

# 2. Fit a model with two outputs
# Fit the model. Including more epochs allows provides more time for the model to converge
model.fit(games_tourney_train[['seed_diff', 'pred']],
  		  games_tourney_train[['score_1', 'score_2']],
  		  verbose=True,
  		  epochs=100,
  		  batch_size=16384)

# 3. Inspect the model
# The output weights were ~ 72. This is because, on average, a team will score about 72 points in a tournament game
# Print the model's weights
print(model.get_weights())

# Print the column means of the training data
print(games_tourney_train.mean())

# 4. Evaluate the model on the test set
# Evaluate the model on the tournament test data
print(model.evaluate(games_tourney_test[['seed_diff', 'pred']], 
        games_tourney_test[['score_1', 'score_2']], verbose=False))
