# Artificial Neural Network

# Activation Functions
# Calculate the first and second hidden layer
hidden_1 = torch.matmul(input_layer, weight_1)
hidden_2 = torch.matmul(hidden_1, weight_2)

# Calculate the output
print(torch.matmul(hidden_2, weight_3))

# Calculate weight_composed_1 and weight
weight_composed_1 = torch.matmul(weight_1, weight_2)
weight = torch.matmul(weight_composed_1, weight_3)

# Multiply input_layer with weight. The result from this matches the output created in the first calculation above
print(torch.matmul(input_layer, weight))

# ReLU activation
# Instantiate non-linearity
relu = nn.ReLU()

# Apply non-linearity on the hidden layers
hidden_1_activated = relu(torch.matmul(input_layer, weight_1))
hidden_2_activated = relu(torch.matmul(hidden_1_activated, weight_2))
print(torch.matmul(hidden_2_activated, weight_3))

# Apply non-linearity in the product of first two weights. 
weight_composed_1_activated = relu(torch.matmul(weight_1, weight_2))

# Multiply `weight_composed_1_activated` with `weight_3
weight = torch.matmul(weight_composed_1_activated, weight_3)

# Multiply input_layer with weight
print(torch.matmul(input_layer, weight))

# ReLU activation again
# Instantiate ReLU activation function as relu
relu = nn.ReLU()

# Initialize weight_1 and weight_2 with random numbers
weight_1 = torch.rand(4, 6)
weight_2 = torch.rand(6, 2)

# Multiply input_layer with weight_1
hidden_1 = torch.matmul(input_layer, weight_1)

# Apply ReLU activation function over hidden_1 and multiply with weight_2
hidden_1_activated = relu(hidden_1)
print(torch.matmul(hidden_1_activated, weight_2))

# Calculating loss function in PyTorch
# Initialize the scores and ground truth
logits = torch.tensor([[-1.2, 0.12, 4.8]])
ground_truth = torch.tensor([2])

# Instantiate cross entropy loss
criterion = nn.CrossEntropyLoss()

# Compute and print the loss. Closer to zero the better the model is at predictions
loss = criterion(logits, ground_truth)
print(loss)

# Loss function of random scores
# Import torch and torch.nn
import torch
import torch.nn as nn

# Initialize logits and ground truth
logits = torch.rand(1, 1000)
ground_truth = torch.tensor([111])

# Instantiate cross-entropy loss
criterion = nn.CrossEntropyLoss()

# Calculate and print the loss. Shows that the prediction would be close to the expected prob. With 1/1000 = 0.001, 6.9 was the expected loss value to return.
# So returning a value close to this makes sense as everything is random.
loss = criterion(logits, ground_truth)
print(loss)

# Preparing the MNIST dataset
# Datasets and dataloader
import torch
import torchvision  # used for transformations
import torch.utils.data # used to transform the data to make it ready for PyTorch
import torchvision.transforms as transforms

# Transform the data to torch tensors and normalize it 
transform = transforms.Compose([transforms.ToTensor(),
								transforms.Normalize((0.1307), ((0.3081)))]) # assigning the Mean and Std

# Prepare training set and testing set. The kw train can be used to segment between training data (True) and testing data (False)
trainset = torchvision.datasets.MNIST('mnist', train=True, 
									                    download=True, transform=transform)
testset = torchvision.datasets.MNIST('mnist', train=False,
			                                download=True, transform=transform)

# Prepare training loader and testing loader. 
# batch_size: relates to the number of pictures being taken to perform analysis
# shuffle: ensures that a random sample is used in the algorithm
trainloader = torch.utils.data.DataLoader(trainset, batch_size=32,
                                          shuffle=True, num_workers=0)
testloader = torch.utils.data.DataLoader(testset, batch_size=32,
										                      shuffle=False, num_workers=0) 

# Inspecting the dataloaders
# Compute the shape of the training set and testing set
trainset_shape = trainloader.dataset.train_data.shape
testset_shape = testloader.dataset.test_data.shape

# Print the computed shapes
print(trainset_shape, testset_shape)

# Compute the size of the minibatch for training set and testing set
trainset_batchsize = trainloader.batch_size
testset_batchsize = testloader.batch_size

# Print sizes of the minibatch
print(trainset_batchsize, testset_batchsize)

# Training Neural Networks
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim

# Define the class Net
class Net(nn.Module):
    def __init__(self):    
    	# Define all the parameters of the net
        super(Net, self).__init__()
        self.fc1 = nn.Linear(28 * 28 * 1, 200)
        self.fc2 = nn.Linear(200, 10)

    def forward(self, x):   
    	# Do the forward pass
        x = F.relu(self.fc1(x)) # uses the activation function in a functional way
        x = self.fc2(x)
        return x

# Instantiate the Adam optimizer and Cross-Entropy loss function
model = Net()   
optimizer = optim.Adam(model.parameters(), lr=3e-4)	# used to optimize the network
criterion = nn.CrossEntropyLoss()
  
for batch_idx, data_target in enumerate(train_loader):
    data = data_target[0]
    target = data_target[1]
    data = data.view(-1, 28 * 28)
    optimizer.zero_grad()

    # Complete a forward pass
    output = model(data)

    # Compute the loss, gradients and change the weights
    loss = criterion(output, target)
    loss.backward()
    optimizer.step()
	
# Make predictions
# Set the model in eval mode
model.eval()

for i, data in enumerate(test_loader, 0):
    inputs, labels = data
    
    # Put each image into a vector
    inputs = inputs.view(-1, 28*28)
    
    # Do the forward pass and get the predictions
    outputs = model(inputs)
    _, outputs = torch.max(outputs.data, 1)
    total += labels.size(0)
    correct += (outputs == labels).sum().item()
print('The testing set accuracy of the network is: %d %%' % (100 * correct / total))
