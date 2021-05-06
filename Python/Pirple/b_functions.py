# Showing functions boilerplate code
# def FunctionName(Input):
#     Action
#     return Output

# Simple function. Values inside a function are local.
# The only way to get the local variable values that you require
# is by using return
def addOne(Number):
    Number += 1
    return Number
# Global variables
Var = 0
print(Var)
# Using the function
Var2 = addOne(Var)
Var3 = addOne(Var2)
Var4 = addOne(2.1)
print(Var2)
print(Var3)
print(Var4)

def addOneAddTwo(NumberOne, NumberTwo):
    Output = NumberOne + 1
    Output += NumberTwo + 2
    return Output

# Sum = addOneAddTwo(1,2)
Sum = addOneAddTwo(Var2,Var3)
print(Sum)