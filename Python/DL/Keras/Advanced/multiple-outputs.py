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

