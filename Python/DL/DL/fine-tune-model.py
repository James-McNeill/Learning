# Fine tuning the keras model

# A. Model Optimization
# 1. Changing optimization parameters
# Import the SGD optimizer
from keras.optimizers import SGD

# Create list of learning rates: lr_to_test. As the learning rate moves the model performance gains change as well.
# A very small learning rate shows some gains. An average learning rate show the optimal gains. A large learning rate
# shows no improvements for this classification exercise
lr_to_test = [0.000001, 0.01, 1]

# Loop over learning rates
for lr in lr_to_test:
    print('\n\nTesting model with learning rate: %f\n'%lr )
    
    # Build new model to test, unaffected by previous models. Function that creates a new model each time to fairly compare the learning rate parameter changes
    model = get_new_model()
    
    # Create SGD optimizer with specified learning rate: my_optimizer
    my_optimizer = SGD(lr=lr)
    
    # Compile the model
    model.compile(optimizer=my_optimizer, loss='categorical_crossentropy')
    
    # Fit the model
    model.fit(predictors, target)

# B. Model Validation
# 1. Evaluating model accuracy on validation dataset
# Save the number of columns in predictors: n_cols
n_cols = predictors.shape[1]
input_shape = (n_cols,)

# Specify the model
model = Sequential()
model.add(Dense(100, activation='relu', input_shape = input_shape))
model.add(Dense(100, activation='relu'))
model.add(Dense(2, activation='softmax'))

# Compile the model
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# Fit the model
hist = model.fit(predictors, target, validation_split=0.3)
