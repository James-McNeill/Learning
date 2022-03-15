# Try block for error handling
try:
    print(int("Hello"))
except:
    print("Entered exception")
    
print("Past exception")

keyWord = "123"
try:
    print(int(keyWord))
except:
    print("Entered exception")
    
print("Past exception")

keyWord = "Hello"
try:
    print(int(keyWord))
except:
    print("Entered exception")
    
print("Past exception")

keyWord = "Hello"
try:
    print(int(keyWord))
except:
    pass # keyword means that nothing is done
    print("Entered exception")
    
print("Past exception")

keyWord = "Hello"
try:
    print(int(keyWord))
except Exception as e: # helps to identify exceptions
    print(str(e))
    
print("Past exception")

keyWord = "Hello"
try:
    print(int(keyWord))
except ValueError: # check for special errors
    print("got a ValueError")
except:
    print("Other type of exception")
finally: # review all the checks and finally we do this
    print("finally")
    
print("Past exception")
