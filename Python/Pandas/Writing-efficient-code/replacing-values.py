# Replacing values in a DataFrame

# A. Replace scalar values using .replace()
# 1. Replacing scalar values I
# Replace Class 1 to -2 
poker_hands['Class'].replace(1, -2, inplace=True)
# Replace Class 2 to -3
poker_hands['Class'].replace(2, -3, inplace=True)

print(poker_hands[['Class', 'Explanation']])

# 2. Replace scalar values II
# a. First method using .loc[]
start_time = time.time()

# Replace all the entries that has 'FEMALE' as a gender with 'GIRL'
names['Gender'].loc[names.Gender == 'FEMALE'] = 'GIRL'

print("Time using .loc[]: {} sec".format(time.time() - start_time))

# b. Second method using .replace(). This pandas method is much more efficient
start_time = time.time()

# Replace all the entries that has 'FEMALE' as a gender with 'GIRL'
names['Gender'].replace('FEMALE', 'GIRL', inplace=True)

print("Time using .replace(): {} sec".format(time.time() - start_time))

# B. Replace values using lists
# 1. Replace multiple values I
start_time = time.time()

# Replace all non-Hispanic ethnicities with 'NON HISPANIC'
names['Ethnicity'].loc[(names["Ethnicity"] == 'BLACK NON HISP') | 
                      (names["Ethnicity"] == 'BLACK NON HISPANIC') | 
                      (names["Ethnicity"] == 'WHITE NON HISP') | 
                      (names["Ethnicity"] == 'WHITE NON HISPANIC')] = 'NON HISPANIC'

print("Time using .loc[]: sec".format(time.time() - start_time))

# b. The pandas method is quicker
start_time = time.time()

# Replace all non-Hispanic ethnicities with 'NON HISPANIC'
names['Ethnicity'].replace(['BLACK NON HISP', 'BLACK NON HISPANIC', 'WHITE NON HISP' , 'WHITE NON HISPANIC'], 'NON HISPANIC', inplace=True)

print("Time using .replace(): {} sec".format(time.time() - start_time))

# 2. Replace multiple values II
start_time = time.time()

# Replace ethnicities as instructed. From the list index values each value will match against each other 
names['Ethnicity'].replace(['ASIAN AND PACI','BLACK NON HISP', 'WHITE NON HISP'], ['ASIAN AND PACIFIC ISLANDER','BLACK NON HISPANIC','WHITE NON HISPANIC'], inplace=True)

print("Time using .replace(): {} sec".format(time.time() - start_time))

# C. Replace values using dictionaries
# 1. Replace single values I
# Replace Royal flush or Straight flush to Flush
poker_hands.replace({'Royal flush':'Flush', 'Straight flush':'Flush'}, inplace=True)
print(poker_hands['Explanation'].head())

# 2. Replace single values II
# Replace the number rank by a string
names['Rank'].replace({1:'FIRST', 2:'SECOND', 3:'THIRD'}, inplace=True)
print(names.head())

# 3. Replace multiple values III
# Replace the rank of the first three ranked names to 'MEDAL'. With this dictionary we can use the first level to identify the feature key that relates to the 
# feature that will be used. The values from this key relate to the values in the feature that will be replaced. Means that multiple features could be updated
# together using the same logic. Would have to test the efficiency of this process step to see if it works better
names.replace({'Rank': {1:'MEDAL', 2:'MEDAL', 3:'MEDAL'}}, inplace=True)

# Replace the rank of the 4th and 5th ranked names to 'ALMOST MEDAL'
names.replace({'Rank': {4:'ALMOST MEDAL', 5:'ALMOST MEDAL'}}, inplace=True)
print(names.head())
