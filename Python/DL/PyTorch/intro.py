# Introduction to PyTorch

# Library is very similar to NumPy

# Creating tensors
# Import torch
import torch

# Create random tensor of size 3 by 3
your_first_tensor = torch.rand(3, 3)

# Calculate the shape of the tensor
tensor_size = your_first_tensor.shape

# Print the values of the tensor and its shape
print(your_first_tensor)
print(tensor_size)

# Create a matrix of ones with shape 3 by 3
tensor_of_ones = torch.ones(3, 3)

# Create an identity matrix with shape 3 by 3
identity_tensor = torch.eye(3)

# Do a matrix multiplication of tensor_of_ones with identity_tensor
matrices_multiplied = torch.matmul(tensor_of_ones, identity_tensor)
print(matrices_multiplied)

# Do an element-wise multiplication of tensor_of_ones with identity_tensor
element_multiplication = tensor_of_ones * identity_tensor
print(element_multiplication)

# Forward pass
# Initialize tensors x, y and z
x = torch.rand(1000, 1000)
y = torch.rand(1000, 1000)
z = torch.rand(1000, 1000)

# Multiply x with y
q = torch.matmul(x, y)

# Multiply elementwise z with q
f = z * q

mean_f = torch.mean(f)
print(mean_f)

# Backpropagation using PyTorch
# Initialize x, y and z to values 4, -3 and 5
x = torch.tensor(4., requires_grad = True)
y = torch.tensor(-3., requires_grad = True)
z = torch.tensor(5., requires_grad = True)

# Set q to sum of x and y, set f to product of q with z
q = x + y
f = q * z

# Compute the derivatives
f.backward()

# Print the gradients
print("Gradient of x is: " + str(x.grad))
print("Gradient of y is: " + str(y.grad))
print("Gradient of z is: " + str(z.grad))

# Calculating gradients
# Multiply tensors x and y
q = torch.matmul(x, y)

# Elementwise multiply tensors z with q
f = z * q

mean_f = torch.mean(f)

# Calculate the gradients
mean_f.backward()

# First neural network
# Initialize the weights of the neural network
weight_1 = torch.rand(784, 200)
weight_2 = torch.rand(200, 10)

# Multiply input_layer with weight_1
hidden_1 = torch.matmul(input_layer, weight_1)

# Multiply hidden_1 with weight_2
output_layer = torch.matmul(hidden_1, weight_2)
print(output_layer)

# Building a Neural Network class
import torch
import torch.nn as nn

# Note that this class worked for a picture
class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        
        # Instantiate all 2 linear layers  
        self.fc1 = nn.Linear(784, 200) # First hidden layer that connected to the input layer. (input_layer, hidden_layer). For this example 784 pixels (28,28)
        self.fc2 = nn.Linear(200, 10) # Second hidden layer connection to the output layer. (hidden_layer, output_layer). There are 10 output nodes

    def forward(self, x):
      
        # Use the instantiated layers and return x
        x = self.fc1(x) # Take input values and create hidden layer
        x = self.fc2(x) # Use hidden layer to create outputs
        return x
      
# Working with a similar class setup
import torch
import torch.nn as nn

# Note that this class worked for a picture
class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.fc1 = nn.Linear(10, 20) # First hidden layer that connected to the input layer. (input_layer, hidden_layer). For this example 784 pixels (28,28)
        self.fc2 = nn.Linear(20, 20) # Second hidden layer connection to the output layer. (hidden_layer, output_layer). There are 10 output nodes
        self.output = nn.Linear(20, 4)
        
    def forward(self, x):
      
        # Use the instantiated layers and return x
        x = self.fc1(x)
        x = self.fc2(x)
        x = self.output(x)
        return x

# Working with this example class
input_layer = torch.rand(10)
net = Net()
result = Net(input_layer)
