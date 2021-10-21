# Find the file names in the current directory
# Method 1
#import os
#import pandas as pd
#
#files = []
#
## print the current directory
#print(os.getcwd())
#
## r = root, d = directory, f = file
#for r, d, f in os.walk(os.getcwd()):
#    for file in f:
##        files.append(os.path.join(r, file))
#        files.append(os.path.join(file))
#        
#for f in files:
#    print(f)

#
#https://www.dotnetperls.com/sort-file-size-python
#Give this method a go

# Method 2

import os
import pandas as pd
import re
from tqdm import tqdm # track progress

#%% Creating an empty DataFrame with only column names but no rows
df = pd.DataFrame(columns=['File_Path', 'Lst_Folder', 'Name', 'Ext'])

print("Empty Dataframe ", df, sep="\n")

#%% print the current directory
print(os.getcwd())

# extract and append data values
#for r, d, f in os.walk(os.getcwd()):
#    for file in f:
##        print("Root: ", r)
##        print("File ", file)
#
#        df = df.append({"File_Path": r, "Name": file}, ignore_index=True)
##        print(df)
#        m = re.split(r"\.", file)
##        print(list(m))
##        print(m[1])
##        Performing a second append creates a separate line. Need to combine with above
#        df = df.append({"Ext": m[1]}, ignore_index=True)
#        print(df)
#        break
#        df.append(, ignore_index=True)

# extract and append data values
for r, d, f in os.walk(os.getcwd()):
    for file in tqdm(f):
        p = re.split(r"\\", r)
        l = "_".join(list(p[5:])) # Only keep the values from the string after the initial home library
        m = re.split(r"\.", file)        
        df = df.append({"File_Path": l, "Lst_Folder": p[-1], "Name": m[0], "Ext": m[1]}, ignore_index=True)
#        print(df)
#        print(list(p[5:]))
#        l = "_".join(list(p[5:]))
#        print(l)
#        print(p[-1])
#        break
