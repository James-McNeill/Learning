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

# B. Single model for classification and regression
# 1. Classification and regression in one model
# In this model, turn off the bias, or intercept for each layer. Note this kind of model is only possible with a Neural Network
# Create an input layer with 2 columns
input_tensor = Input((2,))

# Create the first output
output_tensor_1 = Dense(1, activation='linear', use_bias=False)(input_tensor)

# Create the second output (use the first output as input here)
output_tensor_2 = Dense(1, activation='sigmoid', use_bias=False)(output_tensor_1)

# Create a model with 2 outputs
model = Model(input_tensor, [output_tensor_1, output_tensor_2])

# 2. Compile and fit the model
# Import the Adam optimizer
from keras.optimizers import Adam

# Compile the model with 2 losses and the Adam optimzer with a higher learning rate
model.compile(loss=['mean_absolute_error', 'binary_crossentropy'], optimizer=Adam(lr=0.01))

# Fit the model to the tournament training data, with 2 inputs and 2 outputs
model.fit(games_tourney_train[['seed_diff', 'pred']],
          [games_tourney_train[['score_diff']], games_tourney_train[['won']]],
          epochs=10,
          verbose=True,
          batch_size=16384)

# 3. Inspect the model
# Print the model weights
print(model.get_weights())

# Print the training data means
print(games_tourney_train.mean())

# Import the sigmoid function from scipy
from scipy.special import expit as sigmoid

# Weight from the model
weight = 0.14

# Print the approximate win probability predicted close game (one point score diff, prob was close to 50%)
print(sigmoid(1 * weight))

# Print the approximate win probability predicted blowout game (10 point score diff, prob was close to 80%)
print(sigmoid(10 * weight))
