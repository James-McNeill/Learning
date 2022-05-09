# website: https://github.com/tirthajyoti/Machine-Learning-with-Python/blob/master/Pandas%20and%20Numpy/Numpy_operations.ipynb
# Review the NumPy Operations

#%% 1) Vectors and matrices
import numpy as np

#%% Vector
my_list = [1,2,3]
arr = np.array(my_list)
print("Type/Class of this object", type(arr))
print("Here is the vector\n----------------\n",arr)

#%% Matrix
my_mat = [[1,2,3],[4,5,6],[7,8,9]]
mat = np.array(my_mat)
print("Type/Class of this object", type(mat))
print("Here is the matrix\n--------\n", mat, "\n--------")
print("dimensions: ", mat.ndim, sep=' ')
print("size: ", mat.size, sep=' ')
print("shape: ", mat.shape, sep=' ')
print("datatype: ", mat.dtype, sep=' ')

my_mat = [[1.1,2,3],[4,5.2,6],[7,8.3,9]]
mat = np.array(my_mat)
print("Type/Class of this object: ", type(mat))

b = np.array([(1,2,3), (4,5,6)])
print("matrix made from tuples")
print(b)

#%% 2) Arange and linspace
# A series of numbers from low to high
print("A series of numbers: ", np.arange(5,16))
# Numbers spaced apart by 2
print("Numbers spaced apart by 2: ", np.arange(0,11,2))
# Numbers spaced apart by float
print("Numbers spaced apart by float: ", np.arange(0,11,2.5))
# Every 5th number from 50
print("Every 5th number from 50 in reverse order\n", np.arange(50,-1,-5))
# 21 linearly spaced numbers between 1 and 5
print("21 linearly spaced numbers between 1 and 5\n--------------")
print(np.linspace(1,5,21))

#%% Zeros, ones, empty and identity matrix
print("Vector of zeroes\n----------")
print(np.zeros(5))
print("Matrix of zeroes\n----------")
print(np.zeros((3,4)))
print("Vector of ones\n----------")
print(np.ones(5))
print("Matrix of ones\n----------")
print(np.ones((3,4)))
print("Matrix of fives\n----------")
print(5*np.ones((3,4)))

print("Empty matrix\n--------\n", np.empty((3,5)))
mat1 = np.eye(4)
print("Identity matrix of dimension", mat1.shape)
print(mat1)

#%% 2) Random number generation

print("Random number generation (from Uniform distribution)")
# 2 by 3 matrix with random numbers ranging from 0 to 1, Note no tuple is necessary
print(np.random.rand(2,3))

print("Numbers from Normal distribution with zero mean and standard deviation 1 i.e. standard normal")
print(np.random.randn(4,3))

# randint (Low, high, # of samples to be drawn)
print("Random integer vector: ", np.random.randint(1,101,10))

# randint (Low, high, # of samples to be drawn in a tuple to form a matrix)
print("\nRandom integer matrix")
print(np.random.randint(1,101,(4,4)))

# 20 samples drawn from a dice throw
print("\n20 samples drawn from a dice throw: ", np.random.randint(1,7,20))

#%% Reshaping, min, max, sort
from numpy.random import randint as ri

a = ri(1,100,30)
b = a.reshape(2,3,5)
c = a.reshape(6,5)
print("Shape of a:", a.shape)
print("Shape of b:", b.shape)
print("Shape of c:", c.shape)

print("\na looks like\n",'-'*30,"\n",a,"\n",'-'*30)

print("Max of a:", a.max())
print("Max of a location:", a.argmax())

#%% 3) Indexing and slicing
arr = np.arange(0,11)
print("Array: ",arr)
print("7th index: ",arr[7])
print("3rd to 5th index: ",arr[3:6])
print("4th index: ",arr[:4])
print("From last backwards: ",arr[-1::-1])

#%% Broadcasting (super cool feature)
start = np.zeros((4,3))
print(start)

# Create a rank 1 ndarray with 3 values
add_rows = np.array([1,0,2])
print(add_rows)
# add to each row of start using broadcasting
y = start + add_rows
print(y)
#create an ndarray which is 4 x 1 to broadcast across columns
add_cols = np.array([[0,1,2,3]])
add_cols = add_cols.T
print(add_cols)
#add to each column of start using broadcast
y = start + add_cols
print(y)
#this will just broadcast in both dimensions
add_scalar = np.array([100])
print(start+add_scalar)

#%% NumPy mathematical functions on array
mat1 = np.array(ri(1,10,9)).reshape(3,3)
mat2 = np.array(ri(1,10,9)).reshape(3,3)

A = np.linspace(0,12*np.pi,1001)
import matplotlib.pyplot as plt
plt.scatter(x=A,y=100*np.exp(-A/10)*(np.sin(A)))
plt.title("Exponential decay of sine wave")
plt.show()
