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
