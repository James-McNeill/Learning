# After creating the model it should be saved for easier use. Then the model can be reloaded and predictions can be made with it

from keras.models import load_model

# Store the model for later use after it has been built
model.save('model_file.h5')

# Load the model to be able to make predictions with it. Can use the summary() method to confirm model architecture
my_model = load_model('my_model.h5')

# Make predictions with the model on the data to predict with
predictions = my_model.predict(data_to_predict_with)

# As the model was built on a binary classification problem we can extract the second array column
probability_true = predictions[:,1]
