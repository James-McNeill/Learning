# Review the variables that are in memory during the active session

# library to import
import pandas as pd

# review the directory
for i in dir():
    # displays all of the global variables available
    #print(type(globals()[i]))
    # reviews to understand which variables have the type pandas DataFrame
    if type(globals()[i]) == pd.DataFrame:
        print(type(globals()[i]))
        print(i)
