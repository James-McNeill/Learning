# Collections package

# Counter
# Standard package that comes with Python
from collections import Counter

# Dictionary of each unique value and count
Counter(list)

# Most common value, where N is a integer value. Brings up the most common N unique values in the Counter
Counter(list).most_common(N)

# Defaultdict
# Help when creating a dictionary of data with an unknown structure
from collections import defaultdict

# NamedTuple
from collections import namedtuple
'''
Often times when working with data, you will use a dictionary just so you can use key names to make reading the code 
and accessing the data easier to understand. Python has another container called a namedtuple that is a tuple, but has 
names for each position of the tuple. You create one by passing a name for the tuple type and a list of field names.

For example, Cookie = namedtuple("Cookie", ['name', 'quantity']) will create a container, and you can create new ones 
of the type using Cookie('chocolate chip', 1) where you can access the name using the name attribute, and then get the 
quantity using the quantity attribute.
'''

# Create the namedtuple: DateDetails
DateDetails = namedtuple('DateDetails', ['date', 'stop', 'riders'])
# Create the empty list: labeled_entries
labeled_entries = []
# Iterate over the entries list
for date, stop, riders in entries:
    # Append a new DateDetails namedtuple instance for each entry to labeled_entries
    details = DateDetails(date, stop, riders)
    labeled_entries.append(details)
