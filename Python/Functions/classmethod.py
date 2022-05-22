# Python allows you to define class methods as well, using the @classmethod decorator and a special first argument cls. The main use 
# of class methods is defining methods that return an instance of the class, but aren't using the same code as __init__().

# For example, you are developing a time series package and want to define your own class for working with dates, BetterDate. The attributes
# of the class will be year, month, and day. You want to have a constructor that creates BetterDate objects given the values for year, month, 
# and day, but you also want to be able to create BetterDate objects from strings like 2020-04-30.

# import datetime from datetime
from datetime import datetime

class BetterDate:
    def __init__(self, year, month, day):
      self.year, self.month, self.day = year, month, day
      
    @classmethod
    def from_str(cls, datestr):
        year, month, day = map(int, datestr.split("-"))
        return cls(year, month, day)
