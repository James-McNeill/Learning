# Introduction to deep learning with Python

# A. Forward propogation
# Process of working from the input layer to the hidden layer to the final output layer
# Values contained within the input layer are multiplied by the weights that are connected to the interactions for the hidden layer.
# Details contained within this hidden layer nodes are then multiplied by the weights that connect to the output layer to create the prediction

# First two chapters are aiming to predict the number of bank transactions that a customer will make

# Calculate node 0 value: node_0_value
node_0_value = (input_data * weights['node_0']).sum()

# Calculate node 1 value: node_1_value
node_1_value = (input_data * weights['node_1']).sum()

# Put node values into array: hidden_layer_outputs
hidden_layer_outputs = np.array([node_0_value, node_1_value])

# Calculate output: output
output = (hidden_layer_outputs * weights['output']).sum()

# Print output
print(output)

# B. Activation functions
# Used to introduce non-linear interactions that occur. Aims to move away from simple linear interactions
# These functions are applied at each node to convert the inputs into an output value for that node.

# 1. The Rectified Linear Activation Function. Aims to predict only positive values by taking the maximum of input and zero. Don't want to
# predict negative transaction values
def relu(input):
    '''Define your relu activation function here'''
    # Calculate the value for the output of the relu function: output
    output = max(input, 0)
    
    # Return the value just calculated
    return(output)

# Calculate node 0 value: node_0_output
node_0_input = (input_data * weights['node_0']).sum()
node_0_output = relu(node_0_input)

# Calculate node 1 value: node_1_output
node_1_input = (input_data * weights['node_1']).sum()
node_1_output = relu(node_1_input)

# Put node values into array: hidden_layer_outputs
hidden_layer_outputs = np.array([node_0_output, node_1_output])

# Calculate model output (do not apply relu)
model_output = (hidden_layer_outputs * weights['output']).sum()

# Print model output
print(model_output)
