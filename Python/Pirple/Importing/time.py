# Reviewing the time library
import time

currentTime = time.process_time()
print("Hello")
pastTime = time.process_time()
print(pastTime - currentTime)

# The process will sleep for three seconds
print("1")
time.sleep(3)
print("2")

# Create values within the range. Sleep for 1 second each time
for i in range(1, 11):
    print(i)
    time.sleep(1)
