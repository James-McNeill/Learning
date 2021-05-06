# Different variable types in Python - all global variables as they are not stored within a function
# # Integer
# one = 1
# two = 2
# three = 3

# # Alternative creation of variables
# one, two, three = 1, 2, 3

# # Display variables
# print(one, two, three)
# two = 4
# print(two, one)

# # Float
# decimal = 1.1
# print(decimal)

# # String
# StringVar = "Hello" + "1"
# print(StringVar)

# PI = 3.14159
# print(PI)

# # Showing a local variable in a function
# def FunctionName():
#     #global one, two, three
#     newVar = "World"
#     print(one, two, three)
#     print(newVar)
#     return

# # Local variable will show
# FunctionName()
# Local variable will not show as it is not global. Result = error
# print(newVar)

# Counting variables
count = 0
print(count)
count = count + 1
print(count)
count = count + 1
print(count)
count += 1
print(count)
count = count * 3
print(count)
count *= 3
print(count)
count /= 3
print(count)