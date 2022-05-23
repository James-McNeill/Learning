# Inheritance & Polymorphism
'''
In your company, any data has to come with a timestamp recording when the dataset was created, to make sure that outdated 
information is not being used. You would like to use pandas DataFrames for processing data, but you would need to customize 
the class to allow for the use of timestamps.

In this exercise, you will implement a small LoggedDF class that inherits from a regular pandas DataFrame but has a created_at 
attribute storing the timestamp. You will then augment the standard to_csv() method to always include a column storing the creation date.

Tip: all DataFrame methods have many parameters, and it is not sustainable to copy all of them for each method you're customizing. 
The trick is to use variable-length arguments *args and **kwargsto catch all of them.
'''

# Import pandas as pd
import pandas as pd

# Define LoggedDF inherited from pd.DataFrame and add the constructor
class LoggedDF(pd.DataFrame):
  
  def __init__(self, *args, **kwargs):
    pd.DataFrame.__init__(self, *args, **kwargs)
    self.created_at = datetime.today()
    
  def to_csv(self, *args, **kwargs):
    # Copy self to a temporary DataFrame
    temp = self.copy()
    
    # Create a new column filled with self.created_at
    temp["created_at"] = self.created_at
    
    # Call pd.DataFrame.to_csv on temp, passing in *args and **kwargs
    pd.DataFrame.to_csv(temp, *args, **kwargs)
